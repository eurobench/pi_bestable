function plotResultsWithNormative(filename, personal_data, testbed_data, sorted_data, normative)
################################################################################
# 'plotResultsWithNormative(filename, personal_data, testbed_data, sorted_data, normative)'
# 
# Plots PI results as boxplots and save it in *.pdf
# 
# Copyright BeStable project 2020
# 
################################################################################

figure_handle = figure('Position',[1 41 1920 963],'Visible','off');

annotation(figure_handle,'textbox',[0.00625 0.75 0.09 0.17],...
     'String',{...
     ['Subject ID: ' num2str(personal_data.subject_ID)],'',...
     ['Age: ' num2str(personal_data.subject_age) ' yrs'],...
     ['Height: ' num2str(personal_data.subject_height) ' m'],...
     ['Mass: ' num2str(personal_data.subject_mass) ' kg'],...
     ['Gender: ' personal_data.subject_gender],...
     ['Affected side: ' personal_data.subject_affected_body_side],...
     ['Treadmill speed: ' num2str(testbed_data.treadmill_speed) ' m/s'],...
     ['Pert. amplitude: ' num2str(testbed_data.perturbation_amplitude) ' m']},...
     'FitBoxToText','on');

annotation(figure_handle,'textbox',[0.1 0.20 0.09 0.14],...
     'String',{...
     'BASE walking (before enabling perturbations)',...
     'FREE walking (between perturbations)',...
     'STEP_1 to STEP_4 - consecutive steps after pert. onset'},...
     'FitBoxToText','on');


## NATIVE GAIT #################################################################
# step length
h_subplot_step_length(1) = subplot(4,6,1);
hold on
h0 = boxplots(...
       {normative.base.l_heel_strike.step_length,normative.base.r_heel_strike.step_length;
        normative.free.l_heel_strike.step_length,normative.free.r_heel_strike.step_length},...
        'labels',{'BASE','FREE'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
h1 = boxplots(...
       {sorted_data.base.l_heel_strike.step_length,sorted_data.base.r_heel_strike.step_length;
        sorted_data.free.l_heel_strike.step_length,sorted_data.free.r_heel_strike.step_length},...
        'labels',{'BASE','FREE'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
ylim_step_length(1,:) = ylim;
xlim([0.5 2.5])
hold on
grid
box on
ylabel('Step length (m)')
title('NATIVE GAIT')

# step width
h_subplot_step_width(1) = subplot(4,6,7);
h0 = boxplots(...
       {normative.base.l_heel_strike.step_width,normative.base.r_heel_strike.step_width;
        normative.free.l_heel_strike.step_width,normative.free.r_heel_strike.step_width},...
        'labels',{'BASE','FREE'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
h1 = boxplots(...
       {sorted_data.base.l_heel_strike.step_width,sorted_data.base.r_heel_strike.step_width;
        sorted_data.free.l_heel_strike.step_width,sorted_data.free.r_heel_strike.step_width},...
        'labels',{'BASE','FREE'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
ylim_step_width(1,:) = ylim;
xlim([0.5 2.5])
grid
box on
ylabel('Step width (m)')

# step time
h_subplot_step_time(1) = subplot(4,6,13);
h0 = boxplots(...
       {normative.base.l_heel_strike.step_time,normative.base.r_heel_strike.step_time;
        normative.free.l_heel_strike.step_time,normative.free.r_heel_strike.step_time},...
        'labels',{'BASE','FREE'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
h1 = boxplots(...
       {sorted_data.base.l_heel_strike.step_time,sorted_data.base.r_heel_strike.step_time;
        sorted_data.free.l_heel_strike.step_time,sorted_data.free.r_heel_strike.step_time},...
        'labels',{'BASE','FREE'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
ylim_step_time(1,:) = ylim;
xlim([0.5 2.5])
grid
box on
ylabel('Step time (s)')

L = legend([h1 h0(1)],{'left target step','right target step','normative'});
set(L,'Position',[0.1 0.13 0.1 0.04])


## PERTURBATIONS ###############################################################
fieldNames = fieldnames(sorted_data.pert);
fieldNames = sort(fieldNames);
for j = 1:length(fieldNames)
    
    pertStr = fieldNames{j};
    eval(['plot_pert_data = sorted_data.pert.' pertStr ';'])
    eval(['normative_pert_data = normative.pert.' pertStr ';'])
    
    # step length
    h_subplot_step_length(j+1) = subplot(4,6,j+1);
    boxplots(...
      {normative_pert_data.l_step.step_length(:,1),normative_pert_data.r_step.step_length(:,1);
       normative_pert_data.l_step.step_length(:,2),normative_pert_data.r_step.step_length(:,2);
       normative_pert_data.l_step.step_length(:,3),normative_pert_data.r_step.step_length(:,3);
       normative_pert_data.l_step.step_length(:,4),normative_pert_data.r_step.step_length(:,4)}...
       ,'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
    boxplots(...
      {plot_pert_data.l_step.step_length(:,1),plot_pert_data.r_step.step_length(:,1);
       plot_pert_data.l_step.step_length(:,2),plot_pert_data.r_step.step_length(:,2);
       plot_pert_data.l_step.step_length(:,3),plot_pert_data.r_step.step_length(:,3);
       plot_pert_data.l_step.step_length(:,4),plot_pert_data.r_step.step_length(:,4)}...
       ,'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
    ylim_step_length(j+1,:) = ylim;
    xlim([0.5 4.5])
    grid
    box on
    ylabel('Step length (m)')
    
    switch pertStr
        case 'fw'
            title('FORWARD')
        case 'fwiw'
            title('FORWARD-INWARD')
        case 'iw'
            title('INWARD')
        case 'fwow'
            title('FORWARD-OUTWARD')
        case 'ow'
            title('OUTWARD')
    endswitch
    
    # step width
    h_subplot_step_width(j+1) = subplot(4,6,j+1+6);
    boxplots(...
      {normative_pert_data.l_step.step_width(:,1),normative_pert_data.r_step.step_width(:,1);
       normative_pert_data.l_step.step_width(:,2),normative_pert_data.r_step.step_width(:,2);
       normative_pert_data.l_step.step_width(:,3),normative_pert_data.r_step.step_width(:,3);
       normative_pert_data.l_step.step_width(:,4),normative_pert_data.r_step.step_width(:,4)}...
       ,'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
    boxplots(...
       {plot_pert_data.l_step.step_width(:,1),plot_pert_data.r_step.step_width(:,1);
        plot_pert_data.l_step.step_width(:,2),plot_pert_data.r_step.step_width(:,2);
        plot_pert_data.l_step.step_width(:,3),plot_pert_data.r_step.step_width(:,3);
        plot_pert_data.l_step.step_width(:,4),plot_pert_data.r_step.step_width(:,4)},...
        'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
    ylim_step_width(j+1,:) = ylim;
    xlim([0.5 4.5])
    grid
    box on
    ylabel('Step width (m)')
    
    # step time
    h_subplot_step_time(j+1) = subplot(4,6,j+1+12);
    boxplots(...
      {normative_pert_data.l_step.step_time(:,1),normative_pert_data.r_step.step_time(:,1);
       normative_pert_data.l_step.step_time(:,2),normative_pert_data.r_step.step_time(:,2);
       normative_pert_data.l_step.step_time(:,3),normative_pert_data.r_step.step_time(:,3);
       normative_pert_data.l_step.step_time(:,4),normative_pert_data.r_step.step_time(:,4)}...
       ,'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[.6 .6 .6],[.6 .6 .6]},'Space',0.6,'Width',1,'TickSize',0.9);
    boxplots(...
       {plot_pert_data.l_step.step_time(:,1),plot_pert_data.r_step.step_time(:,1);
        plot_pert_data.l_step.step_time(:,2),plot_pert_data.r_step.step_time(:,2);
        plot_pert_data.l_step.step_time(:,3),plot_pert_data.r_step.step_time(:,3);
        plot_pert_data.l_step.step_time(:,4),plot_pert_data.r_step.step_time(:,4)},...
        'labels',{'STEP_1','STEP_2','STEP_3','STEP_4'},'colors',{[1 .4 .4],[.4 .4 1]},'Space',0.6,'Width',0.5,'TickSize',0.4);
    ylim_step_time(j+1,:) = ylim;
    xlim([0.5 4.5])
    grid
    box on
    ylabel('Step time (s)')
    
    # target error
    subplot(4,12,j*2+1+18*2)
    boxplots({normative_pert_data.l_step.target_error;normative_pert_data.r_step.target_error},...
        'labels',{'L','R'},'colors',{[.6 .6 .6];[.6 .6 .6]},'Space',1,'Width',1,'TickSize',0.9);
    boxplots({plot_pert_data.l_step.target_error;plot_pert_data.r_step.target_error},...
        'labels',{'L','R'},'colors',{[1 .4 .4];[.4 .4 1]},'Space',1,'Width',.5,'TickSize',0.4);
    axis([0 3 0 0.2])
    grid
    box on
    ylabel('Target error (m)')
    
    # success rate
    subplot(4,12,j*2+2+18*2)
    hold on
    bar(1,mean(normative_pert_data.l_step.success_rate),.5,'facecolor',[.6 .6 .6],'edgecolor','none')
    errorbar(1,mean(normative_pert_data.l_step.success_rate),std(normative_pert_data.l_step.success_rate),'k')
    bar(2,mean(normative_pert_data.r_step.success_rate),.5,'facecolor',[.6 .6 .6],'edgecolor','none')
    errorbar(2,mean(normative_pert_data.r_step.success_rate),std(normative_pert_data.r_step.success_rate),'k')
    bar(1,mean(plot_pert_data.l_step.success_rate),.25,'facecolor',[1 .4 .4],'edgecolor','none')
    errorbar(1,mean(plot_pert_data.l_step.success_rate),std(plot_pert_data.l_step.success_rate),'k')
    bar(2,mean(plot_pert_data.r_step.success_rate),.25,'facecolor',[.4 .4 1],'edgecolor','none')
    errorbar(2,mean(plot_pert_data.r_step.success_rate),std(plot_pert_data.r_step.success_rate),'k')
    hold off
    axis([0 3 0 100])
    set(gca,'XTick',1:2,'XTickLabel',{'L','R'});
    grid
    box on
    ylabel('Success rate (%)')
    
endfor

% set y limits
ylim_step_length = [min(ylim_step_length(:)) max(ylim_step_length(:))];
set(h_subplot_step_length,'ylim',ylim_step_length)
ylim_step_width = [min(ylim_step_width(:)) max(ylim_step_width(:))];
set(h_subplot_step_width,'ylim',ylim_step_width)
ylim_step_time = [min(ylim_step_time(:)) max(ylim_step_time(:))];
set(h_subplot_step_time,'ylim',ylim_step_time)


set(figure_handle, "papersize", [25, 15])
set(figure_handle, "paperposition", [0, 0, 25, 15])
print(figure_handle, filename, "-dpdf");
close(figure_handle)

endfunction