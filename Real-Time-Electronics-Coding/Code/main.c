/* ========================================
 *
 *              ELECH410 labs
 *          FreeRTOS example code
 * 
 *                   2019
 *
 * ========================================
*/
#include "project.h"

/* RTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"
#include "queue.h"
#include "semphr.h"

#define TABLE                (4) /* TODO Put your table number here */
                                 /*      Also adapt the receive and transmit buffer in the topDesign tab ! */

#define TASK_STACK_SIZE      (1024)

/* Task definitions */
#define TASK1_NAME           ("Task 1")
#define TASK1_PRIORITY       (3)

#define TASK2_NAME           ("Task 2")
#define TASK2_PRIORITY       (2)

/* Task prototypes */
void task1( void * );
void task2( void * );
CY_ISR_PROTO(ISR_CAN);

/* Function handlers */
TaskHandle_t task1Handler;
TaskHandle_t task2Handler;

/* Function prototypes */

/* Private defines */
#define CAN_ENCODE_TIMEOUT (500)

/* Buffer shift in the Status Registre */
#define CAN_RX_MAILBOX_Instruction_SHIFT (0u)
#define CAN_RX_MAILBOX_Private_SHIFT (1u)

/* Mutexes, semaphores and queues */
SemaphoreHandle_t instructionReceivedSemaphore;
SemaphoreHandle_t privateReceivedSemaphore;

/* Global variables */
uint32 tokenReceivedTime = 0;
/*
 * Installs the RTOS interrupt handlers.
 */
static void freeRTOSInit( void );
uint8_t encode(uint8_t);

int main(void)
{
    /* Enable global interrupts. */
    CyGlobalIntEnable; 
    
    freeRTOSInit();
    LCD_Start();
    KB_Start();
    CAN_Start();

    /* Set CAN interrupt handler to local routine (Should be after CAN_Start() !) */
    CyIntSetVector(CAN_ISR_NUMBER, ISR_CAN);
    CyGlobalIntEnable; /* Enable global interrupts. */
    
    // Create tasks
    xTaskCreate( task1, TASK1_NAME, TASK_STACK_SIZE, NULL, TASK1_PRIORITY, &task1Handler );
    xTaskCreate( task2, TASK2_NAME, TASK_STACK_SIZE, NULL, TASK2_PRIORITY, &task2Handler );
    
    instructionReceivedSemaphore = xSemaphoreCreateBinary();
    privateReceivedSemaphore = xSemaphoreCreateBinary();
        
    // Launch freeRTOS
    vTaskStartScheduler();     
    
    for(;;)
    {
    }
}

void freeRTOSInit( void )
{
/* Port layer functions that need to be copied into the vector table. */
extern void xPortPendSVHandler( void );
extern void xPortSysTickHandler( void );
extern void vPortSVCHandler( void );
extern cyisraddress CyRamVectors[];

	/* Install the OS Interrupt Handlers. */
	CyRamVectors[ 11 ] = ( cyisraddress ) vPortSVCHandler;
	CyRamVectors[ 14 ] = ( cyisraddress ) xPortPendSVHandler;
	CyRamVectors[ 15 ] = ( cyisraddress ) xPortSysTickHandler;
}

void task1( void *arg )
{
    /*
    * When the instruction has been received, it is displayed on the LCD screen.
    * The encoding of the instruction and the transmission of the encoded message must happen in less than 500 ms.
    */
    (void)arg;
    uint8_t encoded = 0u;
    uint32 dt = 0;
    
    for(;;)
    {
        xSemaphoreTake(instructionReceivedSemaphore, portMAX_DELAY);
        
        LCD_ClearDisplay();
        
        dt = xTaskGetTickCount() - tokenReceivedTime;
        if (dt < CAN_ENCODE_TIMEOUT)
        {
            LED3_Write(~LED3_Read());
            
            encoded = encode(CAN_RX_DATA_BYTE(CAN_RX_MAILBOX_Instruction, 0));
            
            LCD_Position(0u, 0u);
            LCD_PutChar(CAN_RX_DATA_BYTE(CAN_RX_MAILBOX_Instruction, 0));                 
            
            dt = xTaskGetTickCount() - tokenReceivedTime;
            if (dt < CAN_ENCODE_TIMEOUT)
            {
                LED4_Write(~LED4_Read());
                
                CAN_TX_DATA_BYTE1(CAN_TX_MAILBOX_Private) = encoded;
                CAN_SendMsgPrivate();
            }
        }
    }
}

void task2( void *arg )
{
    /*
    * When the private code has been received, Task 2 updates the LCD in order to display the private code.
    */
    (void)arg;
    
    for(;;)
    {
        xSemaphoreTake(privateReceivedSemaphore, portMAX_DELAY);

        for (uint8_t i = 0; i < CAN_GET_DLC(CAN_RX_MAILBOX_Private); i++){
            LCD_Position(1u, i);
            LCD_PutChar(CAN_RX_DATA_BYTE(CAN_RX_MAILBOX_Private, i));
        }
    }
}

CY_ISR(ISR_CAN)
{
    /* Clear Receive Message flag */
    CAN_INT_SR_REG.byte[1u] = CAN_RX_MESSAGE_MASK;
    
    if ((CY_GET_REG16((reg16 *) &CAN_BUF_SR_REG.byte[0u]) & (1u << CAN_RX_MAILBOX_Instruction_SHIFT) ) != 0u){
        /*
        * The instruction has been received. The instruction must be encoded and sent over the CAN.
        * tokenReceivedTime is updated to make sure that the 500 ms delay between the reception of the instruction and the transmission
        * of the encoded token is respected.
        */
        LED1_Write(~LED1_Read());
        tokenReceivedTime = xTaskGetTickCount();
        
        /* Acknowledges receipt of new message */
        CAN_RX_ACK_MESSAGE(CAN_RX_MAILBOX_Instruction);

        xSemaphoreGive(instructionReceivedSemaphore);
    }
    
    if ((CY_GET_REG16((reg16 *) &CAN_BUF_SR_REG.byte[0u]) & (1u << CAN_RX_MAILBOX_Private_SHIFT) ) != 0u){
        /* The private code has been received. It is ready to be displayed on the screen. */
        LED2_Write(~LED2_Read());
        
        /* Acknowledges receipt of new message */
        CAN_RX_ACK_MESSAGE(CAN_RX_MAILBOX_Private);

        xSemaphoreGive(privateReceivedSemaphore);
    }
}

uint8_t encode(uint8_t n){
    uint8 mask = (uint8) 0b01001101001110011u >> TABLE;
    n = (n & ~mask) | (~n & mask);
    return n;
}

/* [] END OF FILE */
