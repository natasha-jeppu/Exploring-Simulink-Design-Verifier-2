% This program finds a set of safe states using assertions

% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu

Safex = [];
for i = 1:6  % for all Vertical
    for j = 1:2  % for all AP
        for k = 1:3  % for all AltSel
                
            S=[i j k];
            assert = 1;
            is = 1;
            
            if (S(is,1)== 6 && S(is,3) ~= 3) || (S(is,1)~= 6 && S(is,3) == 3)
                %assertion If Vert = ALTCAP ALTSEL = ALTSEL CAP
                assert = 0;
            end
            if ((S(is,1)==5 && S(is,3) ~= 1))
                %assertion  Vert = ALT Hold then ALTSEL = OFF
                assert = 0;
            end
            if ((S(is,1)==1) && (S(is,2) ~= 2)) || ((S(is,1)~=1) && (S(is,2) == 2))
                %assertion Vert == 1 then AP == OFF
                assert = 0;
            end
            if ((S(is,1)==1) && (S(is,3) ~= 1))
                %assertion Vert == 1 then ALTSEL == OFF
                assert = 0;
            end
            
            if assert == 1
                Safex = [Safex;S]  % Store safe states
            end
            
        end
    end
end

% The computed safe set
% Safex=[     1     2     1
%      2     1     1
%      2     1     2
%      3     1     1
%      3     1     2
%      4     1     1
%      4     1     2
%      5     1     1
%      6     1     3];
