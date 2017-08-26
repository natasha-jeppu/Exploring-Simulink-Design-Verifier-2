% This program runs the simulink "mode_transit_test" for a single frame
% The assertion in the file trap the violations.


% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu

warning off
clear all
clc
tic

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

for is = 1:length(S)  % For all safe states
    
    
    
    for tr = 1:8   % For the 8 triggers
        trignotpos=0;
        if(tr>=5 && tr<=8)
            if(S(is,2)==2)
                %if AP is OFF software triggers ALTS,ALTCAP,ALTCAPDN and
                %APFAIL not possible
                trignotpos=1;
            end
        end
        if (tr==6)
            if S(is,3)~=2
                %if ATLSEL mode is not in ARM state then ALTCAP trigger not
                %possible
                trignotpos=1;
            end
        end
        if(tr==7)
            if S(is,1)~= 6
                %if VERTICAL state not in ALTCAP mode ALTCAPDN trigger not
                %possible
                trignotpos=1;
            end
        end
        if(tr==5)
            if S(is,1) == 5
                %if VERTICAL state in ALTHOLD mode then ALTS trigger not
                %possible
                trignotpos=1;
            end
        end
        
        Tr = zeros(8,1);
        Tr(tr)=1;
        
        if trignotpos==0 % If trigger possible
            
            for c = 1:5  % For all 5 conditions
                ca=zeros(5,1);
                SN = S(is,:);
                
                IC_ALTSARM = (S(is,3)==2);
                IC_ALTSCAP = (S(is,3)==3);
                IC_ALTNOTHOLD = (S(is,1) ~= 5);
                IC_APON = (S(is,2)==1);
                IC_VERT = S(is,1);
                IC_AP = S(is,2);
                IC_ALTS = S(is,3);
                
                
                if(S(is,2)==1) % Some coditions are state dependent
                    ca(2)=1;
                end
                if c ~= 2
                    ca(c)=1;
                end
                Cond = ca;
                
                assert = 1;
                isx = 1;
                
                sim('mode_transit_test');
                
                SN=[vert aps alts];
                if (SN(isx,1)== 6 && SN(isx,3) ~= 3) || (SN(isx,1)~= 6 && SN(isx,3) == 3)
                    %assertion If Vert = ALTCAP ALTSEL = ALTSEL CAP
                    assert = 0;
                end
                if ((SN(isx,1)==5 && SN(isx,3) ~= 1))
                    %assertion  Vert = ALT Hold then ALTSEL = OFF
                    assert = 0
                end
                if ((SN(isx,1)==1) && (SN(isx,2) ~= 2)) || ((SN(isx,1)~=1) && (SN(isx,2) == 2))
                    %assertion Vert == 1 then AP == OFF
                    assert = 0
                end
                if ((SN(isx,1)==1) && (SN(isx,3) ~= 1))
                    %assertion Vert == 1 then ALTSEL == OFF
                    assert = 0
                end
                if assert == 1
                    Safex = [Safex;SN]
                else
                    [S(is,:) SN tr]
                    pause
                end
                
                
                
                
            end
        end
    end
end
toc




