% === CVX Optimizer ALGORITHM ===
function [xij_cvx] = CVX(C, xij, Ti, Lj, Rg, F, wij)

    % --- Dimensions ---
    % Using wij and Rg/F to infer sizes, rather than size(Ti,1) etc.
    [numSats, numPairs] = size(wij);   % satellites × pairs
    numGS = numel(Rg);                 % number of ground stations

    cvx_begin quiet
        variable xij(numSats,numPairs)
        minimize( -1 * sum(sum(xij .* wij)) )

        subject to
            xij >= 0;
            for i = 1:numSats
                sum( xij(i,:) ) <= Ti(i);
            end
            for j = 1:numPairs
                sum( xij(:,j) ) <= Lj(j);
            end

            %Ground-station receiver capacities
            % F is numPairs×2, each row [g1 g2] = ground-station indices
            % For each ground station g, collect all pairs that include g.
            for g = 1:numGS
                
                pair_idx = find( F(:,1) == g | F(:,2) == g );     % indices of all pairs that involve ground station g

                % total load on station g from all satellites and those pairs
                % (summing over satellites, then over those columns)
                sum( sum( xij(:, pair_idx), 2 ) ) <= Rg(g);
            end

    cvx_end

    % Round to nearest integer (0 or 1) after solving relaxation
    xij_cvx = round(xij);

end
