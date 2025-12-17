


% === RANDOM ALGORITHM ===
function [xij_rand] = RANDOM(C, xij, Ti, Lj, Rg, F, wij)
    while ~isempty(C)
        idx=randi(size(C,1)); % Random index
        i = C(idx,1);
        j = C(idx,2);
        [xij, Ti, Lj, Rg, C] = UpdateState(i, j, xij, Ti, Lj, Rg, C, F);
    end
    xij_rand = xij;
end