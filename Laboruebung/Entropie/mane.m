fid = fopen('rfc2795.txt');
text = fread(fid);

t = 'A' : 'Z';
text = upper(text);
n = hist(double(text),1:90); 

plot(double(t), n(t));
n(t)