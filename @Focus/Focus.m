classdef Focus < handle
   
    properties
        
        dpf
        OMR
        V
        
        Root
        
    end
    
    methods
       
        function this = Focus() 
            
            switch computer
                case 'PCWIN64'
                    this.Root = 'C:\Users\LJP\Documents\MATLAB\these\manip_pot_vibrant_data\data\';
%                      this.Root = 'G:\these\pot_vibrant\data\';
            end
            
        end
        
        % -----------------------------------------------------------------
        
        function p = path(this)
           
%             p = [this.Root 'dpf_' num2str(this.dpf) filesep 'OMR_' num2str(this.OMR) filesep 'V_' num2str(this.V) filesep];
            p = [this.Root 'dpf_' num2str(this.dpf) filesep 'OMR_' num2str(this.OMR) filesep 'V_' this.V filesep];
            
        end
        
        % -----------------------------------------------------------------
        
        function D = load(this, filename)
           
            D = load([this.path() filename]);
            
        end
    end
    
end