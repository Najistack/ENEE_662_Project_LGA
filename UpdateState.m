

% === UPDATESTATE FUNCTION ===
function [xij, Ti, Lj, Rg, C] = UpdateState(i, j, xij, Ti, Lj, Rg, C, F)
    % Increment connection count
    xij(i,j) = xij(i,j) + 1;

    % Get ground station pair (gl, gm)
    gl = F(j,1);
    gm = F(j,2);

    % Update resource constraints
    Ti(i) = Ti(i) - 1;
    Lj(j) = Lj(j) - 1;
    Rg(gl) = Rg(gl) - 1;
    Rg(gm) = Rg(gm) - 1;

    % Remove all (i, j') if satellite i is out of capacity
    if Ti(i) == 0
        C(C(:,1) == i, :) = [];
    end

    % Remove all (i', j) if pair j has reached connection limit
    if Lj(j) == 0
        C(C(:,2) == j, :) = [];
    end

    % Remove all pairs involving gl if it has no receivers left
    if Rg(gl) == 0
        toRemove = false(size(C,1),1);
        for idx = 1:size(C,1)
            j2 = C(idx,2);
            if any(F(j2,:) == gl)
                toRemove(idx) = true;
            end
        end
        C(toRemove, :) = [];
    end

    % Same for gm
    if Rg(gm) == 0
        toRemove = false(size(C,1),1);
        for idx = 1:size(C,1)
            j2 = C(idx,2);
            if any(F(j2,:) == gm)
                toRemove(idx) = true;
            end
        end
        C(toRemove, :) = [];
    end
end
