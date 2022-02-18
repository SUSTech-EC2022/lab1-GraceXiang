function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
%% TODO
popsize = 4;
lowerBound = 0;
upperBound = 31;
chromlength = 5;
population = randi([lowerBound, upperBound], popsize, 1);
genotypes = dec2bin(population,5);

% Evaluate the initial population
%% TODO
fitness = objective(population);
bestSoFarFit = fitness(1);
[A,index] = sort(fitness,1,'descend');
fitness_pop = [fitness_pop,A(1)]
for i = 1:popsize
    if fitness(i) > bestSoFarFit
        bestSoFarFit = fitness(i);
        bestSoFarSolution = population(i);
    end
end
nbGen = nbGen +1;
fitness_gen=horzcat(fitness_gen, bestSoFarFit);
solution_gen=horzcat(solution_gen, bestSoFarSolution);

% Start the loop
while (nbGen<T)
    crossoverProb = fitness./sum(fitness); % roulette-wheel selection
    offspringGenes = [];
    % Reproduction (selection, crossver)
    for i = 1:popsize
        parentIndexes = [];
        crossoverProb = fitness./sum(fitness);
        
        r1 = rand();
        for index = 1:popsize
            if r1>sum(crossoverProb(1:index-1)) && r1<=sum(crossoverProb(1:index))
                parentIndexes = [parentIndexes, index];
                break;
            end
        end
        r2 = rand();
        for index = 1:popsize
            if r2>sum(crossoverProb(1:index-1)) && r2<=sum(crossoverProb(1:index))
                parentIndexes = [parentIndexes, index];
                break;
            end
        end
        crossoverPoint = randi(chromlength-1);
        offspringGenes = [offspringGenes; [genotypes(parentIndexes(1),1:crossoverPoint), genotypes(parentIndexes(2),crossoverPoint+1:end)]];
    end
    % Mutation
    offspringGenes
    mutationProb = 1/chromlength;
    for i = 1:popsize
        for j = 1:chromlength
            if rand()<mutationProb;
                if offspringGenes(i, j) == '0'
                    offspringGenes(i, j) = '1';
                else
                    offspringGenes(i, j) = '0';
                end
            end
        end
    end
    population = bin2dec(offspringGenes);
    fitness = objective(population);
    [A,index] = sort(fitness,1,'descend');
    fitness_pop = [fitness_pop,A(1)]
    for i = 1:popsize
        if fitness(i) > bestSoFarFit
            bestSoFarFit = fitness(i);
            bestSoFarSolution = population(i);
        end
    end
    genotypes = dec2bin(population,5);
    fitness_gen=horzcat(fitness_gen, bestSoFarFit);
    solution_gen=horzcat(solution_gen, bestSoFarSolution);
    nbGen = nbGen + 1;
end
bestSoFarFit
bestSoFarSolution

figure,plot(1:nbGen,fitness_gen,'b') 
title('Fitness\_Gen')

figure,plot(1:nbGen,solution_gen,'b') 
title('Solution\_Gen')

figure,plot(1:nbGen,fitness_pop,'b') 
title('Fitness\_Pop')
