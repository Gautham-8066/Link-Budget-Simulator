clear; clc; close all;

% 1. Mission Configuration
f = 437e6;              
P_tx_dBm = 30;          
G_total = 14;           
Sensitivity = -120;     
Altitude_km = 500;      
c = 3e8;

ground_x_fwd = -1500:25:1500; 
ground_x_rev = fliplr(ground_x_fwd(1:end-1)); 
full_path = [ground_x_fwd, ground_x_rev];

% 2. Setup Figure & Layout
fig = figure('Color', 'k', 'Name', 'Seamless Mission Monitor', 'Position', [100 100 1100 500]);
t = tiledlayout(1, 2, 'TileSpacing', 'compact');

% Left Plot: Geometry
ax_sim = nexttile; hold on; grid on; axis equal;
title('Live Satellite Tracking');
xlabel('Distance (km)'); ylabel('Altitude (km)');
xlim([-1600 1600]); ylim([0 600]);
plot(0, 0, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 10); 
sat_obj = plot(NaN, NaN, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
signal_beam = line([0 0], [0 0], 'Color', [0 1 0 0.4], 'LineWidth', 2);

% Right Plot: Link Data
ax_data = nexttile; hold on; grid on;
title('Continuous Link Budget');
xlabel('Slant Range (km)'); ylabel('Signal (dBm)');
ylim([-150 -80]); xlim([400 1600]);

% Zones
fill([0 2000 2000 0], [-105 -105 -80 -80], [0.8 1 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.2); 
fill([0 2000 2000 0], [-120 -120 -105 -105], [1 1 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.2);
fill([0 2000 2000 0], [-150 -150 -120 -120], [1 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.2);

link_line = plot(NaN, NaN, 'b', 'LineWidth', 1.5);
live_dot = plot(NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
status_text = text(500, -85, 'STATUS: SCANNING', 'FontSize', 12, 'FontWeight', 'bold');

% 3. The Infinite Ping-Pong Loop 
all_P_rx = [];
all_ranges = [];

while ishandle(fig)
    for i = 1:length(full_path)
        if ~ishandle(fig), break; end
        
        % Current Position
        current_x = full_path(i);
        
        % Math: Slant Range $d = \sqrt{x^2 + h^2}$
        slant_range_km = sqrt(current_x^2 + Altitude_km^2);
        FSPL = 20*log10(slant_range_km*1000) + 20*log10(f) + 20*log10(4*pi/c);
        current_P_rx = P_tx_dBm + G_total - FSPL;
        
        % Update History 
        % This keeps the plot clean during the reverse pass
        if i == 1 || i == length(ground_x_fwd) + 1
            all_P_rx = current_P_rx;
            all_ranges = slant_range_km;
        else
            all_P_rx = [all_P_rx, current_P_rx];
            all_ranges = [all_ranges, slant_range_km];
        end
        
        % Update Animation
        set(sat_obj, 'XData', current_x, 'YData', Altitude_km);
        set(signal_beam, 'XData', [0 current_x], 'YData', [0 Altitude_km]);
        set(link_line, 'XData', all_ranges, 'YData', all_P_rx);
        set(live_dot, 'XData', slant_range_km, 'YData', current_P_rx);
        
        % Logic/Color Switching
        if current_P_rx > -105
            set(status_text, 'String', 'STATUS: GOOD SIGNAL', 'Color', [0 0.5 0]);
            set(signal_beam, 'Visible', 'on', 'Color', [0 1 0 0.4]);
        elseif current_P_rx > -120
            set(status_text, 'String', 'STATUS: WEAK SIGNAL', 'Color', [0.6 0.6 0]);
            set(signal_beam, 'Visible', 'on', 'Color', [1 1 0 0.4]);
        else
            set(status_text, 'String', 'STATUS: NO CONNECTION', 'Color', [0.8 0 0]);
            set(signal_beam, 'Visible', 'off');
        end
        
        drawnow;
        pause(0.01); 
    end
end
