% Compute algorithm statistics over many randomized trials

N_trials = 20;

% Optimal values
random_opt = zeros(N_trials,1);         % Random choice algo
lgreed_opt = zeros(N_trials,1);         % Local greedy algo
ggreed_opt = zeros(N_trials,1);         % Global greedy algo
cvx_opt = zeros(N_trials,1);            % Convex optimization

% Algorithm run time
random_t = zeros(N_trials,1);           % Random choice algo
lgreed_t = zeros(N_trials,1);           % Local greedy algo
ggreed_t = zeros(N_trials,1);           % Global greedy algo
cvx_t = zeros(N_trials,1);              % Convex optimization

% Compute statistics
for k = 1:N_trials
    [random_opt(k),lgreed_opt(k),ggreed_opt(k),cvx_opt(k),...
        random_t(k),lgreed_t(k),ggreed_t(k),cvx_t(k)] = fixed_test_satellite_routing_algorithms_no_plots();
end

% Plot distributions
figure(1); hist([random_opt lgreed_opt ggreed_opt cvx_opt]); legend('random','local','global','cvx'); grid on; xlabel('optimal value')
figure(2); hist([random_t lgreed_t ggreed_t cvx_t]); legend('random','local','global','cvx'); grid on; xlabel('run time')

fprintf('mean random optimal value: %0.6f\n', mean(random_opt));
fprintf('mean local optimal value: %0.6f\n', mean(lgreed_opt));
fprintf('mean global optimal value: %0.6f\n', mean(ggreed_opt));
fprintf('mean cvx optimal value: %0.6f\n', mean(cvx_opt));
