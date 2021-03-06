n = 7;
M = 50000;
USB_G = 'z^5 + z^2 + z + 1';

% Lineplot
figure(1);

USB_G = 'z^5 + z^2 + z + 1';
x_1 = [];
y_1 = [];
k = 8 * 8;
for f = 1:30
    [non_detected_errors] = fehlerErkennung(M, k, USB_G, f);
    
    nicht_gef_uebertr_fehler_prozent = non_detected_errors / M * 100;
    x_1 = [x_1, f];
    y_1 = [y_1, nicht_gef_uebertr_fehler_prozent];
end


WLAN_G = 'z^32 + z^26 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2  + z + 1';
x_2 = [];
y_2 = [];
k = 8 * 8;
for f = 1:30
    [non_detected_errors] = fehlerErkennung(M, k, WLAN_G, f);
    
    nicht_gef_uebertr_fehler_prozent = non_detected_errors / M * 100;
    x_2 = [x_2, f];
    y_2 = [y_2, nicht_gef_uebertr_fehler_prozent];
end
%%


figure(1);clf

hold on

plot(x_1, y_1, 'DisplayName', 'USB', 'Color', [0,1.0,0]);

plot(x_2, y_2, 'DisplayName', 'WLAN', 'Color', [1.0,0,0]);
xlabel('Fehler');
ylabel(' nicht-gefundener Übertragungsfehler');



% correct only one error
function [non_detected_errors] = fehlerErkennung(M, k, G, f)
    % 1. M zufällige Nachrichten mit einerLängevon k Bitsgeneriert
    
    msgN = randsrc(M, k, [1 0]);
    % 2. Für diese Nachrichten mit dem Generatorpolynom G die CRC-Bits bestimmt
    crcG = comm.CRCGenerator(G, 'ChecksumsPerFrame', M);
    crcD = comm.CRCDetector(G, 'ChecksumsPerFrame', M);
    non_detected_errors = 0;
    msgN = reshape(msgN.',1,[]);
    codewordN = crcG(msgN')';
    
    % 3. pro Nachricht f Bitfehler verursacht (randerr)
    l = length(codewordN) / M;
    randN = reshape(randerr(M, l, [f]).',1, []);
    
    
    codeword_with_error = mod(codewordN + randN, 2);

    % 4. die fehlerhafte Nachricht auf Fehler überprüft
    [~,err] = crcD(codeword_with_error');

    % 5. die Anzahl der nicht-gefundenen fehlerhaften Nachrichten zurückgibt
    non_detected_errors = M - sum(err);
end