classdef Focus < handle
   
    properties
        
        dpf
        OMR
        V
        date
        
        Root
        
    end
    
    methods
       
        function this = Focus() 
            
            switch computer
                case 'PCWIN64'
                    this.Root = 'C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\data\';
%                      this.Root = 'G:\these\pot_vibrant\data\';
            end
            
        end
        
        % -----------------------------------------------------------------
        
        function p = path(this)
           
%             p = [this.Root 'dpf_' num2str(this.dpf) filesep 'OMR_' num2str(this.OMR) filesep 'V_' num2str(this.V) filesep];
            p = [this.Root num2str(this.dpf) '_dpf'  filesep this.V '_Vpp' filesep 'OMR_' this.OMR filesep this.date filesep];
            
        end
        
        % -----------------------------------------------------------------
        
        function D = load(this, filename)
           
            D = load([this.path() filename]);
            
        end
    end
    
end