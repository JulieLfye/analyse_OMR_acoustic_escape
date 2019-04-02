% test code

close all

figure;
plot(vel(limwindow(1):limwindow(2)));

acc = diff(vel(limwindow(1):limwindow(2)));
m = max(acc);
[mags, peak] = findpeaks(acc, 'MinPeakHeight',m*0.8);
figure;
plot(acc);
hold on;
plot(peak,mags,'o');

mi = min(acc);

itest = peak-5;
acc1 = mags;
while itest > 0
    acc2 = acc(itest);
    if acc2<acc1
        itest = itest - 1;
        acc1 = acc2;
    else
     indb = itest+1;
     itest = 0;
    end
end

plot(indb, acc(indb),'ro')