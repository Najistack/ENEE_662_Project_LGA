
% === LOCAL GREEDY ALGORITHM ===
function [xij_local] = LOCAL_GREEDY(C, xij, Ti, Lj, Rg, F, wij)
    while ~isempty(C)
        % Step 1: Find available pairs
        Fprime = unique(C(:,2)); % Valid ground station pairs

        % Step 2: Randomly choose a pair j
        j = Fprime(randi(length(Fprime)));

        % Step 3: Choose i with max wij among those that can connect to j
        candidates = C(C(:,2) == j, 1); % All i such that (i,j) ∈ C
        [~, idx] = max(wij(candidates,j));
        i = candidates(idx);

        % Step 4: Update state
        [xij, Ti, Lj, Rg, C] = UpdateState(i, j, xij, Ti, Lj, Rg, C, F);
    end
    xij_local = xij;
end
