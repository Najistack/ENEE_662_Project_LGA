function [ran, loc, glo, cvx]=test_satellite_routing_algorithms(wij,F,Ti,Lj,Rg,do_plot)
    % === TEST SCRIPT FOR SATELLITE-GROUND CONNECTION ALGORITHMS ===
    % Modifed from the original:
    %   Now initialization is done outside this function.  This function 
    %   will get called once per timestep.  It will now return the decision
    %   variables for each of the algorithms: RANDOM, LOCAL_GREEDY, 
    %   GLOBAL_GREEDY, and the relaxed convext optimization algorithm.
    %
    %   So now all wij and xij matrices are 2D.  Also, the output 
    %   variables have been renamed for readability and compactness.
    %

    % --- Initialize variables
    numSat = size(Ti,1);            % Number of satellites
    numPairs = size(Lj,1);          % Number of ground stations
    numGS = size(Rg,1);             % Number of ground station pairs
    xij = zeros(numSat,numPairs);   % Decision variable

    % --- Build valid connection list C (where wij > 0) ---
    C = [];
    for i = 1:numSat
        for j = 1:numPairs
            if wij(i,j) > 0
                C = [C; i, j];
            end
        end
    end

    % --- Clone inputs for each algorithm ---
    t_start = tic;
    [xij_rand]   = RANDOM(C, xij, Ti, Lj, Rg, F, wij);
    time_rand = toc(t_start);
    ran = struct('xij', xij_rand, 'runtime', time_rand);        % Output
    
    t_start = tic;
    [xij_local]  = LOCAL_GREEDY(C, xij, Ti, Lj, Rg, F, wij);
    time_local = toc(t_start);
    loc = struct('xij', xij_local, 'runtime', time_local);      % Output

    t_start = tic;
    [xij_global] = GLOBAL_GREEDY(C, xij, Ti, Lj, Rg, F, wij);
    time_global = toc(t_start);
    glo = struct('xij', xij_global, 'runtime', time_global);    % Output

    t_start = tic;
    [xij_cvx] = CVX(C, xij, Ti, Lj, Rg, F, wij);
    time_cvx = toc(t_start);
    cvx = struct('xij', xij_cvx, 'runtime', time_cvx);    % Output

    %% === Plot Results ===
    if do_plot
        
        figure(1);
        bar3(wij); title('Wij'); xlabel('Pair j'); ylabel('Satellite i');

        figure(2);
        subplot(2,2,1); bar3(xij_rand); title('RANDOM'); xlabel('Pair j'); ylabel('Satellite i');
        subplot(2,2,2); bar3(xij_local); title('LOCAL GREEDY'); xlabel('Pair j'); ylabel('Satellite i');
        subplot(2,2,3); bar3(xij_global); title('GLOBAL GREEDY'); xlabel('Pair j'); ylabel('Satellite i');
        subplot(2,2,4); bar3(xij_cvx); title('RELAXED CONVEX'); xlabel('Pair j'); ylabel('Satellite i');
    end

end
