function subject = BeStable_import_data(fileName)


%% SUBJECT CHARACTERISTICS
subjectCharacteristics = dlmread(fileName,',',[2 0 2 7]);

subject.ID      = subjectCharacteristics(1);
subject.age     = subjectCharacteristics(2);
subject.height  = subjectCharacteristics(3);
subject.mass    = subjectCharacteristics(4);

if subjectCharacteristics(5) == 1
    subject.gender = 'male';
else
    subject.gender = 'female';
end

switch subjectCharacteristics(6)
    case 1
        subject.affectedSide = 'left';
    case 2
        subject.affectedSide = 'right';
    case 3
        subject.affectedSide = 'none';
end

subject.treadmillSpeed        = subjectCharacteristics(7);
subject.perturbationAmplitude = subjectCharacteristics(8);


%% SUBJECT DATA
opts = delimitedTextImportOptions('NumVariables', 9);
opts.DataLines = [5, Inf]; % Specify range
opts.Delimiter = ','; % Specify delimiter
% Specify column names and types
opts.VariableNames = ["stepNumber", "timeStamp", "limbInitial", "limbFinal", "stepWidth", "stepLength", "stepTime", "targetError", "message"];
opts.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "double", "double", "categorical"];
opts = setvaropts(opts, [3, 4, 9], 'EmptyFieldRule', 'auto');
opts.ExtraColumnsRule = 'ignore';
opts.EmptyLineRule = 'read';
DATA = readtable(fileName, opts); % Import the data
DATA.targetError(DATA.targetError == -1) = NaN; % Replace -1 with NaN
clear opts subjectCharacteristics % Clear temporary variables


%% SEGMENT PERTURBATIONS
dataSegmented = struct(...
    'base',[],...
    'free',[],...
    'pert',[]);
subject.dataRaw = DATA;

pert_en = false;
idx_baseR = 1;
idx_baseL = 1;
idx_freeR = 1;
idx_freeL = 1;
flag_continue = 0;
idx_fwWithLeftLeg = 1;
idx_fwWithRightLeg = 1;
idx_iwWithLeftLeg = 1;
idx_iwWithRightLeg = 1;
idx_fwiwWithLeftLeg = 1;
idx_fwiwWithRightLeg = 1;
idx_fwowWithLeftLeg = 1;
idx_fwowWithRightLeg = 1;
idx_owWithLeftLeg = 1;
idx_owWithRightLeg = 1;
NO_STEPS_AFTER_PERT = 4;

for n = 1:length(DATA.message)
    str_message = char(DATA.message(n));
    
    if flag_continue <= NO_STEPS_AFTER_PERT && flag_continue >= 1
        flag_continue = flag_continue - 1;
        continue;
    end
    
    if strcmp(str_message,'free') && ~pert_en
        
        if strcmp(char(DATA.limbFinal(n)),'R')
            dataSegmented.base.rightHeelStrike.stepLength(idx_baseR) = DATA.stepLength(n);
            dataSegmented.base.rightHeelStrike.stepWidth(idx_baseR) = DATA.stepWidth(n);
            dataSegmented.base.rightHeelStrike.stepTime(idx_baseR) = DATA.stepTime(n);
            idx_baseR = idx_baseR + 1;
        else
            dataSegmented.base.leftHeelStrike.stepLength(idx_baseL) = DATA.stepLength(n);
            dataSegmented.base.leftHeelStrike.stepWidth(idx_baseL) = DATA.stepWidth(n);
            dataSegmented.base.leftHeelStrike.stepTime(idx_baseL) = DATA.stepTime(n);
            idx_baseL = idx_baseL + 1;
        end
        
    elseif contains(str_message,'Pert')
        
        pert_en = true;
        
        switch str_message(7:end)
            case 'fw (L)'
                dataSegmented.pert.fw.withLeftLeg.stepLength(idx_fwWithLeftLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withLeftLeg.stepWidth(idx_fwWithLeftLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withLeftLeg.stepTime(idx_fwWithLeftLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withLeftLeg.targetError(idx_fwWithLeftLeg) = DATA.targetError(n+2);
                idx_fwWithLeftLeg = idx_fwWithLeftLeg + 1;
            case 'fw (R)'
                dataSegmented.pert.fw.withRightLeg.stepLength(idx_fwWithRightLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withRightLeg.stepWidth(idx_fwWithRightLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withRightLeg.stepTime(idx_fwWithRightLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fw.withRightLeg.targetError(idx_fwWithRightLeg) = DATA.targetError(n+2);
                idx_fwWithRightLeg = idx_fwWithRightLeg + 1;
            case 'iw (L)'
                dataSegmented.pert.iw.withLeftLeg.stepLength(idx_iwWithLeftLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withLeftLeg.stepWidth(idx_iwWithLeftLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withLeftLeg.stepTime(idx_iwWithLeftLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withLeftLeg.targetError(idx_iwWithLeftLeg) = DATA.targetError(n+2);
                idx_iwWithLeftLeg = idx_iwWithLeftLeg + 1;
            case 'iw (R)'
                dataSegmented.pert.iw.withRightLeg.stepLength(idx_iwWithRightLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withRightLeg.stepWidth(idx_iwWithRightLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withRightLeg.stepTime(idx_iwWithRightLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.iw.withRightLeg.targetError(idx_iwWithRightLeg) = DATA.targetError(n+2);
                idx_iwWithRightLeg = idx_iwWithRightLeg + 1;
            case 'fwiw (L)'
                dataSegmented.pert.fwiw.withLeftLeg.stepLength(idx_fwiwWithLeftLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withLeftLeg.stepWidth(idx_fwiwWithLeftLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withLeftLeg.stepTime(idx_fwiwWithLeftLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withLeftLeg.targetError(idx_fwiwWithLeftLeg) = DATA.targetError(n+2);
                idx_fwiwWithLeftLeg = idx_fwiwWithLeftLeg + 1;
            case 'fwiw (R)'
                dataSegmented.pert.fwiw.withRightLeg.stepLength(idx_fwiwWithRightLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withRightLeg.stepWidth(idx_fwiwWithRightLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withRightLeg.stepTime(idx_fwiwWithRightLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwiw.withRightLeg.targetError(idx_fwiwWithRightLeg) = DATA.targetError(n+2);
                idx_fwiwWithRightLeg = idx_fwiwWithRightLeg + 1;
            case 'fwow (L)'
                dataSegmented.pert.fwow.withLeftLeg.stepLength(idx_fwowWithLeftLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withLeftLeg.stepWidth(idx_fwowWithLeftLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withLeftLeg.stepTime(idx_fwowWithLeftLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withLeftLeg.targetError(idx_fwowWithLeftLeg) = DATA.targetError(n+2);
                idx_fwowWithLeftLeg = idx_fwowWithLeftLeg + 1;
            case 'fwow (R)'
                dataSegmented.pert.fwow.withRightLeg.stepLength(idx_fwowWithRightLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withRightLeg.stepWidth(idx_fwowWithRightLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withRightLeg.stepTime(idx_fwowWithRightLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.fwow.withRightLeg.targetError(idx_fwowWithRightLeg) = DATA.targetError(n+2);
                idx_fwowWithRightLeg = idx_fwowWithRightLeg + 1;
            case 'ow (L)'
                dataSegmented.pert.ow.withLeftLeg.stepLength(idx_owWithLeftLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withLeftLeg.stepWidth(idx_owWithLeftLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withLeftLeg.stepTime(idx_owWithLeftLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withLeftLeg.targetError(idx_owWithLeftLeg) = DATA.targetError(n+2);
                idx_owWithLeftLeg = idx_owWithLeftLeg + 1;
            case 'ow (R)'
                dataSegmented.pert.ow.withRightLeg.stepLength(idx_owWithRightLeg,:) = DATA.stepLength(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withRightLeg.stepWidth(idx_owWithRightLeg,:) = DATA.stepWidth(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withRightLeg.stepTime(idx_owWithRightLeg,:) = DATA.stepTime(n+1:n+NO_STEPS_AFTER_PERT);
                dataSegmented.pert.ow.withRightLeg.targetError(idx_owWithRightLeg) = DATA.targetError(n+2);
                idx_owWithRightLeg = idx_owWithRightLeg + 1;
        end
        flag_continue = NO_STEPS_AFTER_PERT;
        
    elseif strcmp(str_message,'free') && pert_en
        
        if strcmp(char(DATA.limbFinal(n)),'R')
            dataSegmented.free.rightHeelStrike.stepLength(idx_freeR) = DATA.stepLength(n);
            dataSegmented.free.rightHeelStrike.stepWidth(idx_freeR) = DATA.stepWidth(n);
            dataSegmented.free.rightHeelStrike.stepTime(idx_freeR) = DATA.stepTime(n);
            idx_freeR = idx_freeR + 1;
        else
            dataSegmented.free.leftHeelStrike.stepLength(idx_freeL) = DATA.stepLength(n);
            dataSegmented.free.leftHeelStrike.stepWidth(idx_freeL) = DATA.stepWidth(n);
            dataSegmented.free.leftHeelStrike.stepTime(idx_freeL) = DATA.stepTime(n);
            idx_freeL = idx_freeL + 1;
        end
        
    end
    
end

subject.dataSegmented = dataSegmented;

