% This program runs the mutant files with random inputs.
%
% It uses the x=GenRandomBool(NoOfTransitions,EndTime,dt) function from 
% http://www.mathworks.com/matlabcentral/fileexchange/44168-random-signal-generation
% with permission

% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu

warning off
clear all
clc
tic

for iter = 1:100  % Run 100 random runs
    % Safe States
    S=[ %  1     2     1  % This is a disconnect state and this can be taken as a special case
        2     1     1
        2     1     2
        3     1     1
        3     1     2
        4     1     1
        4     1     2
        5     1     1
        6     1     3];
    
    Safex =[];
    
    % Vertical Mode
    V=[02	00	00	00	00	00	00	00
        01	03	04	05	00	06	00	01
        01	02	04	05	00	06	00	01
        01	03	02	05	00	06	00	01
        01	03	04	02	00	00	00	01
        01	00	00	05	00	00	05	01
        ];
    % AP Mode
    AP=[02	00	00	00	00	00	00	02
        01	00	00	00	00	00	00	00
        ];
    %Altsel Mode
    AS=[00	00	00	00	02	00	00	00
        01	00	00	01	01	03	00	01
        01	00	00	01	00	00	01	01
        ];
    
    %Condition Matrix - vertical
    CV=[01	00	00	00	00	00	00	00
        02	03	04	05	00	00	00	02
        02	00	04	05	00	00	00	02
        02	03	00	05	00	00	00	02
        02	03	04	00	00	00	00	02
        02	00	00	05	00	00	00	02
        ];
    %Condition Matrix - AP
    CAP=[00	00	00	00	00	00	00	00
        01	00	00	00	00	00	00	00
        ];
    %Condition Matrix - AltSel
    CAS=[00	00	00	00	00	00	00	00
        02	00	00	05	00	00	00	02
        02	00	00	05	00	00	00	02
        ];
    
    %=GenRandomBool(100,50,0.01);
    t=0:0.01:50;t=t'; % Create a time vector
    % APFAIL_INP=[t zeros(size(t))];  % If the user wants to set constants
    % AP_INP=[t zeros(size(t))];
    
    APFAIL_INP=GenRandomBool(100,50,0.01);  % Generate random boolean toggles
    AP_INP=GenRandomBool(100,50,0.01);
    ALTCPDN_INP=GenRandomBool(100,50,0.01);
    ATLCAP_INP=GenRandomBool(100,50,0.01);
    ALT_INP=GenRandomBool(100,50,0.01);
    ALTS_INP=GenRandomBool(100,50,0.01);
    SPD_INP=GenRandomBool(100,50,0.01);
    VS_INP=GenRandomBool(100,50,0.01);
    C1_INP=GenRandomBool(100,50,0.01);
    C3_INP=GenRandomBool(100,50,0.01);
    C4_INP=GenRandomBool(100,50,0.01);
    C5_INP=GenRandomBool(100,50,0.01);
    
    is=round(rand*(length(S)-1))+1;  % Select a random safe state
    
    
    IC_ALTSARM = (S(is,3)==2);  % Set some initial conditions that are state dependent
    IC_ALTSCAP = (S(is,3)==3);
    IC_ALTNOTHOLD = (S(is,1) ~= 5);
    IC_APON = (S(is,2)==1);
    IC_VERT = S(is,1);
    IC_AP = S(is,2);
    IC_ALTS = S(is,3);
    
    try
        sim('mutant1'); %Enter mutant number 1 to 9 to run specific mutant
        
    catch ME
        
        disp(['After ',num2str(iter),' iterations']);  % When the SDV catches errors Simulink fails.
        toc                                            % This shows the mutant is killed
        disp(ME.message)
        break
    end
end








