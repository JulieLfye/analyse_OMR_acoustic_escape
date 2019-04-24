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
                    this.Root = 'D:\OMR_acoustic_experiments\OMR_acoustic\data\';
%                      this.Root = 'G:\these\all_190327\data_OMR_acoustic\data\';
            end
            
        end
        
        % -----------------------------------------------------------------
        
        function p = path(this)
           
%             p = [this.Root 'dpf_' num2str(this.dpf) filesep 'OMR_' num2str(this.OMR) filesep 'V_' num2str(this.V) filesep];
            p = [this.Root num2str(this.dpf) '_dpf'  filesep this.V '_Vpp' filesep 'OMR_' this.OMR filesep];
            
        end
        
        % -----------------------------------------------------------------
        
        function D = load(this, filename)
           
            D = load([this.path() filename]);
            
        end
    end
    
end