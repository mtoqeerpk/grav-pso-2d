%*******************************************************************************
% Purpose:  Executes the PSO algorithm
%
% Outputs:  - This script add some information to the global grav2d_results
%             structure, mainly populated by grav2d_Cost.m function:
%             - grav2d_results.filename: Path of the file where the structure is
%                                        contained
%             - grav2d_results.inv_res.dispersion: Column vector containing the
%                              median dispersio of each iteration
%             - grav2d_results.inv_res.rel_misfit_best: Column vector containing
%                              the relative misfit, in percentage, for the best
%                              model of each iteration (containing the regional
%                              trend, if it was estimated in the inversion)
%             - grav2d_results.model: 'model' struct for the PSO execution
%             - grav2d_results.data: 'data' struct for the PSO execution
%             - grav2d_results.options: 'options' struct for the PSO execution
%             - grav2d_results.opfun: 'opfun' struct for the PSO execution
%             - grav2d_results.original_pso: matriz of swarm_size x iterations
%                              rows containing the original PSO generated models
%                              (the first columns contain the subsoil and then
%                              come the regional trend parameters, if exist)
%           - The grav2d_results is exported as a *.mat file (version 7)
%
% History:  25-07-2018: Function creation
%                       José Luis García Pallero, jgpallero@gmail.com
%*******************************************************************************
%Clear previous global variable
clear('grav2d_results');
%Global variable to store results
global grav2d_results;
%Identifier of new inversion, because this script calls pso_family(), which
%calls grav2d_Cost, where grav2d_results is employed
grav2d_results.extra.new_inversion = 1;
%Identifier for filtering in the first iteration: 0/1 -> no filter/filter
grav2d_results.extra.filt_first_it = 0;
grav2d_results.extra.filt_first_it_o = grav2d_results.extra.filt_first_it;
%Add the PSO software input and output structures
grav2d_results.model = model;
grav2d_results.data = data;
grav2d_results.options = options;
grav2d_results.opfun = opfun;
%PSO EXECUTION
tic;
results = pso_family(@grav2d_Cost,model,data,options,opfun);
fprintf('PSO execution time: %.1f s\n',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Add the best models misfit
grav2d_results.inv_res.rel_misfit_best = results.error_iter';
%Add the median dispersion to the structure
grav2d_results.inv_res.dispersion = results.stat.distmed;
%Add the original models generated by PSO
grav2d_results.inv_res.original_pso = results.historia;
%Filename
grav2d_results.filename = [data.output.folder,filesep,data.output.prefix,...
                           'grav2d_results.mat'];
%Export the structure to a file
fprintf(2,'Saving results to a file\n');
save(grav2d_results.filename,'grav2d_results','-v7');
fprintf(2,'Done!\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2018-2019, J.L.G. Pallero, jgpallero@gmail.com,
%                         J.L. Fernández Martínez, jlfm@uniovi.es
%                         Z. Fernández Muñiz, zulima@uniovi.es
%                         Sylvain Bonvalot, sylvain.bonvalot@ird.fr
%
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without
%modification, are permitted provided that the following conditions are met:
%
%- Redistributions of source code must retain the above copyright notice, this
%  list of conditions and the following disclaimer.
%- Redistributions in binary form must reproduce the above copyright notice,
%  this list of conditions and the following disclaimer in the documentation
%  and/or other materials provided with the distribution.
%- Neither the name of the copyright holders nor the names of its contributors
%  may be used to endorse or promote products derived from this software without
%  specific prior written permission.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
%ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT,
%INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
%BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
%LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
%OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
%ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.