% distance - biterror-rate
k = 1500*8; % 8 Bit-Payload

bits = randi([0 1], k, 1)';

% 10Mbps -> 1 bit / us 
% Abtastrate = 1Ghz -> 1 Abtastwert pro ns
bitrate = 10000000;
n = 100;
T = length(bits)/bitrate;
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
y = zeros(1,length(t));
for i=1:length(bits)
  if bits(i)==1
    y((i-1)*n+1:(i-1)*n+n/2) = 1;
    y((i-1)*n+n/2:i*n) = -1;
  else
    y((i-1)*n+1:(i-1)*n+n/2) = -1;
    y((i-1)*n+n/2:i*n) = 1;
  end
end
t = t(1:end-1);
y=y(1:end-1);


% -- 6. simulation
% sampling frequency
Fs = 1000000000; % 1GHz
% d = 10000; % cable length
d_arr = [100:100:2000];


figure(1);
xlabel('Distance [m]');
ylabel('Probability [%]');
        

for cat = ["CAT 3" "CAT 5"]
    bit_err_arr = [];
    for d = d_arr
        y_recv = transmit10BaseT(y, Fs, d, cat);

        % manchester decoding
        y_recv = reshape(y_recv, length(y_recv)/k, k)';
        [y_len, x_len] = size(y_recv); 
        x_len = round(x_len /3);
        for i = 1:y_len
          value = y_recv(i,:);
          value = value + abs(min(value));
          % left > rigth -> 1 else 0
          % ignore the middlepart  
          
          if sum(value(1:x_len)) > sum(value(length(value) - (x_len):end))
              result(i) = 1;
            else result(i) = 0;
          end
        end

        bit_error = biterr(result, bits);
        bit_err_arr = [bit_err_arr, bit_error];
    end
    hold on
    bit_err_arr  = bit_err_arr / k * 100;
    plot(d_arr, bit_err_arr, 'DisplayName', cat);
end
legend;

%% biterror-rate - tranmission-rate (6 / 7)
k = 1500*8; % 8 Bit-Payload

bits = randi([0 1], k, 1)';

% 10Mbps -> 10 bit / us 
% Abtastrate = 1Ghz -> 1 Abtastwert pro ns



% -- 6. simulation
d = 100; % cable length
n = 100; % samples
bitrate_arr = [5:100:100000];

figure(1);
xlabel('bitrate [Mbps]');
ylabel('Probability [%]');

for cat = ["CAT 3" "CAT 5"]
    bit_err_arr = [];
    
    for bitrate = bitrate_arr
        bitrate = bitrate * 1000000; % Mbps

        Fs =  bitrate * n; % sampling frequency
        T = length(bits)/bitrate;
        N = n*length(bits);
        dt = T/N;
        t = 0:dt:T;
        y = zeros(1,length(t));

        for i=1:length(bits)
              if bits(i)==1
                    y((i-1)*n+1:(i-1)*n+n/2) = 1;
                    y((i-1)*n+n/2:i*n) = -1;
              else
                    y((i-1)*n+1:(i-1)*n+n/2) = -1;
                    y((i-1)*n+n/2:i*n) = 1;
              end
        end
        t = t(1:end-1);
        y=y(1:end-1);

        y_recv = transmit10BaseT(y, Fs, d, cat);

        % manchester decoding
        y_recv = reshape(y_recv, length(y_recv)/k, k)';
        [y_len, x_len] = size(y_recv); 
        x_len = round(x_len /3);
        for i = 1:y_len
              value = y_recv(i,:);
              value = value + abs(min(value));
              % left > rigth -> 1 else 0
              % ignore the middlepart  

              if sum(value(1:x_len)) > sum(value(length(value) - (x_len):end))
                    result(i) = 1;
               else result(i) = 0;
              end
        end

        bit_error = biterr(result, bits);
        bit_err_arr = [bit_err_arr, bit_error];
        
    end
    hold on
    bit_err_arr  = bit_err_arr / k * 100;
    plot(bitrate_arr, bit_err_arr, 'DisplayName', cat);
    
end
legend;


