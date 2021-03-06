function freq_wow_record=sub_freq_wow(lists_cmd,options)
% freq_wow_record=sub_freq_wow(lists_cmd,options)
% frequented write update ratio - WOW
%
% inputs
%   lists_cmd: n samples x 3 for LBA, size, flags
%   options: control parameters
%       plot_fontsize: the figure's font size
%       plot_figure: >=1: plot the figure; otherwise not; default 1
%       save_figure: >=1: save the figures
%       export_report: >=1: export the figure/data into a ppt
%       report_name: report name
%       output_foldername: the output folder name for figures and report; default =''
%       offset_time:  some trace is not started from zone. in this case. need to find the starting time of first event.
%       spec_stack=[10,20,30];  % a vector specify the stack distance, for which we can collect the statistical value and output to the ppt file. for very large dataset ; otherwise specify some small numbers
% outputs
%   freq_wow_record: structure for statistics of frequented WOW
%
% Author: jun.xu99@gmail.com 

if isfield(options, 'plot_fontsize')
    plot_fontsize=options.plot_fontsize;
else
    plot_fontsize=10;
end

if isfield(options, 'save_figure')
    save_figure=options.save_figure;
else
    save_figure=1;
end

if isfield(options, 'plot_figure') 
    plot_figure=options.plot_figure;
else
    plot_figure=1;
end

%     %% write on write
options.drive_max_lba=2*1024^4/512;
[update_stat]=write_update_freq(lists_cmd, 0,options);
freq_wow_record=update_stat;

if plot_figure==1
    f_cdf=figure;
    figure(f_cdf);
    plot(update_stat.freq_idx,update_stat.freq_cdf,'b-')
    xlabel('Maximum number of updates ');
    ylabel('Percentage of blocks updated');
    title('Write Update CDF (blocks)')
    set(findall(gcf,'-property','FontSize'),'FontSize',plot_fontsize)
    grid on;
    saveas(gcf,'freq_update_b.eps', 'psc2');
    saveas(gcf,'freq_update_b.fig');
    
    c_cdf=figure;
    figure(c_cdf);
    plot(update_stat.freq_idx,update_stat.c_freq_cdf,'b-')
    xlabel('Maximum number of updates ');
    ylabel('Percentage of commands updated');
    title('Write Update CDF (Commands)')
    set(findall(gcf,'-property','FontSize'),'FontSize',plot_fontsize);
    grid on;
    saveas(gcf,'freq_update_c.eps', 'psc2');
    saveas(gcf,'freq_update_c.fig');
end

if options.export_report
    options.section_name='Frequented WOW'
    generate_ppt(options)
end
