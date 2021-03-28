%% nr 1
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;

figure;
plot(x,y,'Color',[0,1.0,0]);
xlabel('Zeichen (sortiert)');
ylabel('Häufigkeit');

%% nr 2
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;
[v, i] = maxk(y, 10);  %14 = h

b = bar(v);
set(b,'FaceColor',[1.0,0.7,0]);
set(gca,'xticklabel',char(x(i)));
xlabel('Zeichen');
ylabel('Häufigkeit');

%% nr 3
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;
[v, i] = maxk(y, 10);  %14 = h

summe = sum(y);
y_summe = y / summe;
y_tmp = log2(1./y_summe);

% Lineplot
figure;
plot(x, y_tmp,'Color',[0,1.0,0]);
xlabel('Zeichen (sortiert)');
ylabel('Häufigkeit');

%{
% Barplot
b = bar(y_tmp);
set(b,'FaceColor',[1.0,0.7,0]);
set(gca,'xticklabel',char(x));
xlabel('Zeichen');
ylabel('Informationsgehalt');
%}

%{
fprintf("Auftrittswahrscheinlichkeiten:")
for i = 1:length(tmp)
    fprintf('%s is %.2d\n', char(x(i)), tmp(i))
end
%}

%% nr 4 - benoetigt nr3-code
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)');
[v, i] = maxk(y, 10);  %14 = h

summe = sum(y);
y_summe = y / summe;
y_tmp = log2(1./y_summe);

summe = sum(y_summe .* y_tmp);

fprintf("Entropie der Nachrichtenquelle: %s\n", num2str(summe));
