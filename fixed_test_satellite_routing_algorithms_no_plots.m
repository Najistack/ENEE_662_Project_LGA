function [total_val_rand,total_val_local,total_val_global,total_val_cvx,time_rand,time_local,time_global,time_cvx]=fixed_test_satellite_routing_algorithms_no_plots()
    % === TEST SCRIPT FOR SATELLITE-GROUND CONNECTION ALGORITHMS ===
    % This test script initializes parameters and calls three algorithms:
    % RANDOM, LOCAL_GREEDY, and GLOBAL_GREEDY, then compares their outputs and updates states accordingly.

    %% === Parameter Initialization ===
    
    numSat = 15;  % Number of satellites
    numGS = 10;   % Number of ground stations
    numPairs = 45; % Number of ground station pairs

    % --- Ground station pairs (F) ---
    % Format: each row is a pair [g1, g2]
    [wij,F]=compile_wij;
    % Commented out  F b/c the compile Wij will generate using slant.m


    % --- Satellite capacity (Ti): connections each satellite can make
    %Ti = [2; 1; 1];  % size: numSat x 1 old hardcoding for smaller problem
    Ti= ones(1, numSat);
    % --- Pair capacity (Lj): how many total connections allowed per pair
    %Lj = [1; 1; 2];  % size: numPairs x 1
    Lj = ones(1,numPairs);
    %1;1;2 this is the correct Lj that adheres to the minimum or equal to,
    %based upon Rg

    % --- Receivers available per ground station (Rg) ---
   % Rg = [1; 2; 3];  % size: numGS x 1
   Rg = ones(1,numGS);

    % --- Connection values (wij): benefit of each satellite connecting to each pair
    % commenting out previous- since using compile WIJ....[wij,S,G] = compute_wij(numSat,F);

    % --- Initialize decision variable xij ---
    xij = zeros(numSat, numPairs, size(wij,3)); % making xij 3-dimensional now added the 3rd element
    
 for t=1:size(wij,3)
    % --- Build valid connection list C (where wij > 0) ---
    C = [];
    for i = 1:numSat
        for j = 1:numPairs
            if wij(i,j,t) > 0
                C = [C; i, j];
            end
        end
    end

    % --- Clone inputs for each algorithm ---
    t_start = tic;
    [xij_rand(:,:,t)]   = RANDOM(C, xij(:,:,t), Ti, Lj, Rg, F, wij(:,:,t));
    time_rand = toc(t_start);

    t_start = tic;
    [xij_local(:,:,t)]  = LOCAL_GREEDY(C, xij(:,:,t), Ti, Lj, Rg, F, wij(:,:,t));
    time_local = toc(t_start);

    t_start = tic;
    [xij_global(:,:,t)] = GLOBAL_GREEDY(C, xij(:,:,t), Ti, Lj, Rg, F, wij(:,:,t));
    time_global = toc(t_start);

     t_start = tic;
     [xij_cvx(:,:,t)] = CVX(C, xij(:,:,t), Ti, Lj, Rg, F, wij(:,:,t));
     time_cvx = toc(t_start);
 end % this is the end of the time loop

    %% === Evaluation ===
    total_val_rand = sum(sum(sum(xij_rand .* wij)));
    total_val_local = sum(sum(sum(xij_local .* wij)));
    total_val_global = sum(sum(sum(xij_global .* wij)));
    total_val_cvx = sum(sum(sum(xij_cvx .* wij)));


end
