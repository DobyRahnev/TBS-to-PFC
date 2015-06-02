function sd = compute_sd_from_t(mean_value, t, n)

%t = mean / (SD / sqrt(n))
%thus, SD = mean * sqrt(n) / t

sd = mean_value * sqrt(n) / t;
