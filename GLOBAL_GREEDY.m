
% === GLOBAL GREEDY ALGORITHM ===
function [xij_global] = GLOBAL_GREEDY(C, xij, Ti, Lj, Rg, F, wij)
    while ~isempty(C)
        % Evaluate all current values
        values = arrayfun(@(idx) wij(C(idx,1), C(idx,2)), 1:size(C,1));
        [~, idx] = max(values);

        i = C(idx,1);
        j = C(idx,2);

        % Update state
        [xij, Ti, Lj, Rg, C] = UpdateState(i, j, xij, Ti, Lj, Rg, C, F);
    end
    xij_global = xij;
end
