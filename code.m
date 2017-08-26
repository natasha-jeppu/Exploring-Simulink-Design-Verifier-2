% This program validates the mode transition table using assertions

% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu


warning off
clear all
clc
tic

% Safe States
S=[ 1     2     1
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
    
    
    for tr = 1:8      % For the 8 triggers
        
        trignotpos=0; % Some triggers are not possible
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
        
        if trignotpos==0 % If trigger possible
            
            for c = 1:5    % For all 5 conditions
                ca=zeros(5,1);
                SN = S(is,:);
                
                if(S(is,2)==1) % Some coditions are state dependent
                    ca(2)=1;
                end
                if c ~= 2
                    ca(c)=1;
                end
                
                % Compute the state transitions for vertical
                if V(S(is,1),tr) ~= 0
                    if(CV(S(is,1),tr)==0)
                        SN(1)=V(S(is,1),tr);
                    elseif ( ca(CV(S(is,1),tr)) == 1)
                        SN(1)=V(S(is,1),tr);
                    end
                end
                
                % Compute the state transitions for AP
                if AP(S(is,2),tr) ~= 0
                    if(CAP(S(is,2),tr)==0)
                        SN(2)=AP(S(is,2),tr);
                    elseif ( ca(CAP(S(is,2),tr)) == 1)
                        SN(2)=AP(S(is,2),tr);
                    end
                end
                
                % Compute the state transitions for AltSel
                if AS(S(is,3),tr) ~= 0
                    if(CAS(S(is,3),tr)==0)
                        SN(3)=AS(S(is,3),tr);
                    elseif ( ca(CAS(S(is,3),tr)) == 1)
                        SN(3)=AS(S(is,3),tr);
                    end
                end
                
            end
        end                % Trigger possible
        
        % Compute assertion violations
        assert = 1;
        isx = 1;
        
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
toc




