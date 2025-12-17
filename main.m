function [] = main()
    % === TEST SCRIPT FOR SATELLITE-GROUND CONNECTION ALGORITHMS ===
    % Mostly based on the original fixed_test_satellite_routing_algorithms
    % but now we have a main function that initializes and sets up a for
    % loop that steps through each time slice of the wij matrix.
    %
    % We're only going to look at the first 110 indices of the wij matrix
    % (rest of it seems to produce very little pairing...)
    %
    
    do_plot = 0;        % If you want to look at the bar plots...

    %% Simulation is based on computed slant range data.  Go get it here.
    [wij,F]=compile_wij;
    wij = wij(:,:,1:110);           % Only looking at first 110 minutes

    %% === Parameter Initialization ===

    numSat = size(wij,1);           % Number of satellites
    numGS = numel(unique(F(:)));    % Number of ground stations
    numPairs = size(F,1);           % Number of ground station pairs

    % --- Satellite capacity (Ti): connections each satellite can make
    Ti = ones(numSat,1);

    % --- Pair capacity (Lj): how many total connections allowed per pair
    Lj = ones(numPairs);

    % --- Receivers available per ground station (Rg) ---
    Rg = ones(numGS,1);

    % --- Initialize optimal values ---
    rand_val = zeros(size(wij,3), 1);    % Random algorithm
    local_val = zeros(size(wij,3),1);    % Local greedy algorithm
    global_val = zeros(size(wij,3),1);   % Global greedy algorithm
    cvx_val = zeros(size(wij,3),1);      % relaxed convex algorithm

    % --- Loop through each instance of time ---
    for t = 1:size(wij,3)
        % --- Compute decision variables ---
        [ran,loc,glo,cvx] = test_satellite_routing_algorithms(wij(:,:,t),F,Ti,Lj,Rg,do_plot);

        % -- Compute optimal values ---
        rand_val(t) = sum(sum(ran.xij .* wij(:,:,t)));
        local_val(t) = sum(sum(loc.xij .* wij(:,:,t)));
        global_val(t) = sum(sum(glo.xij .* wij(:,:,t)));
        cvx_val(t) = sum(sum(cvx.xij .* wij(:,:,t)));
    end

    %% === Plot Results ===
    tbase = 1:size(wij,3);
    figure(1)
    plot(tbase,rand_val,'b-',tbase,local_val,'r-',tbase,global_val,'g-',tbase,cvx_val,'k-');
    grid minor; xlabel('time index'); ylabel('entanglement rate')
    legend('random','local greedy', 'global greedy', 'relaxed convex')

end
