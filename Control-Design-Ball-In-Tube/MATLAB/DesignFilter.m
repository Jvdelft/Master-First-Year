function Filter = DesignFilter(order, passband, sample)
    hpFilt = designfilt('lowpassiir','FilterOrder',order, ...
         'PassbandFrequency',passband, 'SampleRate',sample);
     Filter = tf(hpFilt);
     zplane(Filter)
end