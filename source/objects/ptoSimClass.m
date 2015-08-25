%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ptoSimClass<handle
    properties
        
        name = 'NOT DEFINED'
        
        pistonCF               = struct('Ap'              ,'NOT DEFINED',...
                                        'Vo'              ,'NOT DEFINED',...
                                        'Beta_e'          ,'NOT DEFINED',...
                                        'pAi'             ,'NOT DEFINED',...
                                        'pBi'             ,'NOT DEFINED',...
                                        'number'          ,[])
                       
        pistonNCF              = struct('topA'            ,'NOT DEFINED',...
                                        'botA'            ,'NOT DEFINED',...
                                        'number'          ,[])
                     
        checkValve             = struct('Cd'              ,'NOT DEFINED',...
                                        'Amax'            ,'NOT DEFINED',...
                                        'Amin'            ,'NOT DEFINED',...
                                        'pMax'            ,'NOT DEFINED',...
                                        'pMin'            ,'NOT DEFINED',...
                                        'rho'             ,'NOT DEFINED',...
                                        'k1'              ,'NOT DEFINED',...
                                        'k2'              ,'NOT DEFINED',...
                                        'number'          ,[])
                       
        valve                  = struct('number'          ,[])
        
        accummulator           = struct('VI0'             ,'NOT DEFINED',...
                                        'pIrated'         ,'NOT DEFINED',...
                                        'pIupper_limit'   ,'NOT DEFINED',...
                                        'pIlower_limit'   ,'NOT DEFINED',...
                                        'pIprecharge'     ,'NOT DEFINED',...
                                        'VImax'           ,'NOT DEFINED',...
                                        'VImin'           ,'NOT DEFINED',...
                                        'VIeq'            ,'NOT DEFINED',...
                                        'pIeq'            ,'NOT DEFINED',...
                                        'number'          ,[])
                                                              
        hydraulicMotor         = struct('angVelInit'      ,'NOT DEFINED',...
                                        'alpha'           ,'NOT DEFINED',...
                                        'D'               ,'NOT DEFINED',...
                                        'J'               ,'NOT DEFINED',...
                                        'bg'              ,'NOT DEFINED',...
                                        'bf'              ,'NOT DEFINED',...
                                        'number'          ,[])
                       
        rotaryGenerator        = struct('TgenBase'        ,'NOT DEFINED',...
                                        'omegaBase'       ,'NOT DEFINED',...
                                        'driveEff'        ,'NOT DEFINED',...
                                        'number'           ,[])
                       
        linearGenerator        = struct('Rs'              ,'NOT DEFINED',...
                                        'Bfric'           ,'NOT DEFINED',...
                                        'tau_p'           ,'NOT DEFINED',...
                                        'lambda_fd'       ,'NOT DEFINED',...
                                        'Ls'              ,'NOT DEFINED',...
                                        'theta_d_0'       ,'NOT DEFINED',...
                                        'lambda_sq_0'     ,'NOT DEFINED',...
                                        'lambda_sd_0'     ,'NOT DEFINED',...
                                        'Rload'           ,'NOT DEFINED',...
                                        'number'          ,[])
                                                       
         motionMechanism       = struct('crank'           ,'NOT DEFINED',...
                                        'offset'          ,'NOT DEFINED',...
                                        'rodInit'         ,'NOT DEFINED',...
                                        'rodLength'       ,'NOT DEFINED',...
                                        'number'          ,[])
                           
                           
                         
    end
    
    
    methods
        function obj        = ptoSimClass(name)
                 obj.name   = name;
        end    
        
        function countblocks(obj)
            names = {'pistonCF','pistonNCF','checkValve','valve','accummulator','hydraulicMotor','rotaryGenerator','linearGenerator','motionMechanism'};
            for jj = 1:length(names)
                for kk = 1:length(obj.(names{jj}))
                    obj.(names{jj})(kk).number = kk;
                end
            end
        end
        
        function ptosimOutput = response(obj)
            names = {'pistonCF','pistonNCF','checkValve','valve','accummulator','hydraulicMotor','rotaryGenerator','linearGenerator','motionMechanism'};
            
            signals.pistonCF = {'absPower','force','pos','vel'};
            signals.pistonNCF = {'absPower','force','topPressure','bottomPressure'};
            signals.checkValve = {'volFlow1','volFlow2','volFlow3','volFlow4'};
            signals.valve = {'volFlow'};
            signals.accummulator = {'pressure','volume'};
            signals.hydraulicMotor = {'angVel','volFlowM','torque'};
            signals.rotaryGenerator = {'elecPower','genPower'};
            signals.linearGenerator = {'absPower','force','fricForce','Ia','Ib','Ic','Va','Vb','Vc','vel','elecPower'};
            signals.motionMechanism = {'ptoTorque','angPosition','angVelocity'};
            
            ptosimOutput = struct;
            for ii = 1:length(names)
                for jj = 1:length(obj.(names{ii}))
                    for kk = 1:length(signals.(names{ii}))
                        try
                            tmp = evalin('base',[names{ii} num2str(jj) '_out.signals.values(:,' num2str(kk) ')']);
                            ptosimOutput.(names{ii})(jj).(signals.(names{ii}){kk}) = tmp;
                        end
                    end
                    evalin('base',['clear ' names{ii} num2str(jj) '_out']);
                end
            end
            

        end
    end 
end

