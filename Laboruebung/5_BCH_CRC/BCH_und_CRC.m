WLAN_G = 'z^32 + z^26 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2  + z + 1';

p = 0.005
n = 16383;
k = 500 * 8; % Bytes
M = 10000; % payloads

% CRC-Prüfbits
crcG = comm.CRCGenerator(WLAN_G);
crcD = comm.CRCDetector(WLAN_G);

% + BCH-Code
bch_gen_poly = bchgenpoly(n, k);
bch_enc = comm.BCHEncoder(n, k, bch_gen_poly);
bch_dec = comm.BCHDecoder(n, k, bch_gen_poly);

         
errorRate = comm.ErrorRate();
errorFrame = comm.ErrorRate();

for idx = 1:M
    % k - crc-parityBits
    data = randi([0 1], k-32, 1);
    crc_encodedData = step(crcG, data);
    bch_encodedData = step(bch_enc, crc_encodedData);
    
    bch_encodedData_err = bsc(bch_encodedData,p); % Binary symmetric channel
    
    
    errorFrame = step(errorRate, bch_encodedData, bch_encodedData_err);
    
    bch_decodedData = step(bch_dec, bch_encodedData_err);
    crc_decodedData = step(crcD, bch_decodedData);
    
    errorStats = step(errorRate, data, crc_decodedData);
end

fprintf('Residual error probability = %f\nNumber of errors = %d\n', ...
  errorStats(1), errorStats(2))

fprintf('Frame error rate = %f\nNumber of errors = %d\n', ...
  errorFrame(1), errorFrame(2))

% receivedBits = bch_dec(demodSignal);
% [~,err] = crcD(codeword_with_error');
