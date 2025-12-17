function[Wij,F]= compile_wij()
%% Create Wij from slant range data
% Input: slantRanges (15 x 10 x 1440) - satellites x ground stations x time
% Output: Wij (15 x 45 x 1440) - satellites x GS pairs x time
%         F (45 x 2) - lookup table for ground station pairs

clear Wij F;

% Assuming your slant range variable is called 'slantRanges'
% If it's named differently, change the variable name below
% slantRanges = results.slantRanges;  % Uncomment if loading from results
load('satellite_slant_ranges.mat');
slantRanges=results.slantRanges;
[numSats, numGS, numTimes] = size(slantRanges);

%% Create F - lookup table for ground station pairs
% Generate all unique pairs of ground stations (combinations, not permutations)
F = [];
pairIdx = 1;
for gs1 = 1:(numGS-1)
    for gs2 = (gs1+1):numGS
        F(pairIdx, :) = [gs1, gs2];
        pairIdx = pairIdx + 1;
    end
end

numPairs = size(F, 1);
fprintf('Created F lookup table with %d ground station pairs\n', numPairs);
fprintf('Example pairs:\n');
fprintf('  Pair 1: GS%d - GS%d\n', F(1,1), F(1,2));
fprintf('  Pair 2: GS%d - GS%d\n', F(2,1), F(2,2));
fprintf('  Pair 3: GS%d - GS%d\n', F(3,1), F(3,2));

%% Create Wij - 15 x 45 x 1440
Wij = zeros(numSats, numPairs, numTimes);

fprintf('\nComputing Wij values...\n');

for satIdx = 1:numSats
    for pairIdx = 1:numPairs
        gs1 = F(pairIdx, 1);
        gs2 = F(pairIdx, 2);
        
        for tIdx = 1:numTimes
            d1 = slantRanges(satIdx, gs1, tIdx);
            d2 = slantRanges(satIdx, gs2, tIdx);
            
            % Calculate 1/d1 * 1/d2
            % If either is NaN, result is NaN
            if isnan(d1) || isnan(d2)
                Wij(satIdx, pairIdx, tIdx) = 0;
            else
                Wij(satIdx, pairIdx, tIdx) = (1/d1) * (1/d2);
            end
        end
    end
    
    % Progress indicator
    if mod(satIdx, 5) == 0
        fprintf('  Processed %d/%d satellites\n', satIdx, numSats);
    end
end

fprintf('Wij computation complete!\n');
fprintf('Wij dimensions: %d satellites x %d pairs x %d time steps\n', numSats, numPairs, numTimes);

%% Display sample statistics
fprintf('\n=== Wij Statistics ===\n');
totalWij = numel(Wij);
validWij = sum(~isnan(Wij(:)));
fprintf('Total Wij elements: %d\n', totalWij);
fprintf('Valid (non-NaN) elements: %d (%.2f%%)\n', validWij, (validWij/totalWij)*100);

validValues = Wij(~isnan(Wij));
if ~isempty(validValues)
    fprintf('Wij range: %.6e to %.6e\n', min(validValues), max(validValues));
    fprintf('Wij mean: %.6e\n', mean(validValues));
end
end
%% Save results
%save('Wij_results.mat', 'Wij', 'F', '-v7.3');
%disp('Saved Wij and F to Wij_results.mat');

%% Display F lookup table
%fprintf('\n=== F Lookup Table (first 10 pairs) ===\n');
%fprintf('%-10s %-10s %-10s\n', 'Pair Index', 'GS1', 'GS2');
% for i = 1:min(10, numPairs)
%     fprintf('%-10d %-10d %-10d\n', i, F(i,1), F(i,2));
% end
% if numPairs > 10
%     fprintf('... (%d more pairs)\n', numPairs - 10);
% end