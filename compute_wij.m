function [wij,S,G] = compute_wij(N,F)
    % Inputs:
    %   N = number of satellites
    %   F = ground station pairs
    %
    % Outputs:
    %   wij = matrix where each element is 1/distance between ith satellite
    %   and the ground station pair j.
    %   S = 2D position of satellites
    %   G = 2D position of ground stations
    %
    % Uses uniform distribution to place ground stations and satellite
    % positions
    %

   
    % Get number of ground stations and pairs
    numGS = numel(unique(F(:)));
    numPairs = size(F,1);

    % Scatter ground stations and satellites around region
    D = 10e3;                      % Size of the playing field
    G = D* (0.5 - rand(numGS,2)); % Position of ground stations
    S = D* (0.5 - rand(N,2));   % Position of satellites
    

    % For each satellite and ground station pair, compute distance
    wij = zeros(N,size(F,1));       % output variable
    for ii = 1:N
        Si = S(ii,:);       % Position of ii satellite

        for jj = 1:numPairs
            Fj = F(jj,:);   % Ground station pair jj
            
            % Ground stations in this current pair
            gl = Fj(1);
            gm = Fj(2);
            
            % Positions of ground stations 1 and 2
            G1 = G(gl,:);
            G2 = G(gm,:);

            % Sum of the distances to the ground stations
            d1 = sqrt( (Si(1)-G1(1))^2 + (Si(2)-G1(2))^2 );
            d2 = sqrt( (Si(1)-G2(1))^2 + (Si(2)-G2(2))^2 );
           % d = d1 + d2; commenting out b/c it should be eta or transmissivity=(1/d1)*(1/d2)
         
            
            % Return "benefit" (smaller distance = more benefit)
            wij(ii,jj) =(1/d1)*(1/d2);

        end
    end

end
