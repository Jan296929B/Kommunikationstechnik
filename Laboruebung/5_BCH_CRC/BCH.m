% Bedingungen:
% m >= 3
% t_min >= 2t + 1
q = 2;
k = 500*8;
p = 0.5; % percentage
max_frame_fehlerrate = 0.01;

% Task 1 ------------------------------------------------
% -------------------------------
% bestimme n und t
% -------------------------------
% Start-values
% m = |log2(500*8)| = 12
% t = 0

% Schritt: 1:
%t +=1 solange nicht:
% t >= binoinv(1 - 0.01, 500*8+m*t, 0.005)
% Schritt 2:

% m +=1 solange nicht:
% 2^m -1 >= 500*8 + m*t

% gilt Schritt Eins noch?
% -------------------------------

% Bestimme n und t  für eine Framgröße von k = 500 *8 Bit

% Startm = 12, t = 0
t = 34;
m = 14; %13

% Task 2 ------------------------------------------------
n = 2^m - 1;
% d_min = 2*t + 1;
% max_parity_bits = m * t;
% check n in bchnumerr(n);

% Task 3 ------------simulation----------------------
% n = 255;
% k = 239;
gen_poly = bchgenpoly(n, k);
enc = comm.BCHEncoder(n, k, gen_poly);
dec = comm.BCHDecoder(n, k, gen_poly);
errorRate = comm.ErrorRate();

for counter = 1:20
    
    data = randi([0 1], k, 1);
    encodedData = step(enc, data);

    % generate errors
    encodedData = bsc(encodedData,p/100); % Binary symmetric channel
    
  
	receivedBits = step(dec, encodedData);
	errorStats = step(errorRate, data, receivedBits);
end

fprintf('Error rate = %f\nNumber of errors = %d\n', ...
  errorStats(1), errorStats(2))

%{
mod = comm.DPSKModulator('BitInput',true);
chan = comm.AWGNChannel(...
         'NoiseMethod','Signal to noise ratio (SNR)','SNR',10);
demod = comm.DPSKDemodulator('BitOutput',true);
errorRate = comm.ErrorRate();

for counter = 1:20
  data = randi([0 1], k, 1);
  encodedData = step(enc, data);
  modSignal = step(mod, encodedData);
  receivedSignal = step(chan, modSignal);
  demodSignal = step(demod, receivedSignal);
  receivedBits = step(dec, demodSignal);
  errorStats = step(errorRate, data, receivedBits);
end
fprintf('Error rate = %f\nNumber of errors = %d\n', ...
  errorStats(1), errorStats(2))

%}