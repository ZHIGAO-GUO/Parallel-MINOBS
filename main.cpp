#include<iostream>
#include <string>
#include<fstream>
#include <sys/time.h>
#include<stdlib.h>
#include "instance.h"
#include "ordering.h"
#include "localsearch.h"
#include "localsearch.h"
#include "debug.h"
#include "resultregister.h"
#include <unistd.h>
#include "util.h"
#include "types.h"
#include "math.h"
#include <time.h>
#include "population.h"

void usage() {
  std::cerr <<
    "Command without optinal arguemnts\n\n" <<
    "\t./search <instance-file-1> <instance-file-2> <instance-file-3> <instance-file-4> <instance-file-5> <instance-file-6> <instance-file-7> <instance-file-8> <instance-file-9> <instance-file-10> <cutofftime> <seed> <output file>\n\n" <<
    "If <seed> is -1, the current time will be used as the seed.\n" <<
    "Full command (with all optional arguments): \n\n" <<
    "\t./search  <instance-file> <cutofftime> <seed> <output file> -populationsize <pop size>\n\t-crossover <# of crossovers> -nummutation <# of mutations>\n\t-divlookahead <check paper> -numkeep <check paper>\n\t-crossovertype <check paper> -powerfactor <check paper>\n\n" <<
    "By default, the tuned parameters in the paper are used.\n" <<
    "The result is printed to std::out at the end and a file with progress is dumped.\n\n" <<
    "For more information, feel free to contact me at cdlee@edu.uwaterloo.ca.\n";
} 

int main(int argc, char* argv[]) {
  if (argc < 5) {
    usage();
    return 0;
  }
  Types::Score opt;
  std::string fileName1 = argv[1];
  Instance instance1(fileName1);
  int n = instance1.getN();
  float cutoffTime = atof(argv[11]);

  int seed = atoi(argv[12]);
  std::string outFile = argv[13];
  seed = seed == -1 ? time(NULL) : seed;
  ResultRegister rr;
  srand(seed);

  int initPopulationSize = 20;
  int numCrossovers = 20;
  int numMutations = 6;
  int mutationPower = ceil(n*0.01);
  int divLookahead = 20;
  int numKeep = 4;


  int markMAX1 = 1;
  int markMAX2 = 1;


  float divTolerance = 0.001;
  int greediness = -1;
  CrossoverType crossoverType = CrossoverType::OB;
  for (int i = 14; i < 31 && i < argc; i++) {
    std::string param(argv[i]);
    DBG(argv[i]);
    if (param == "-populationsize") {
      initPopulationSize = atoi(argv[i+1]);
    } else if (param == "-crossover") {
      numCrossovers = atoi(argv[i+1]);
    } else if (param == "-nummutation") {
      numMutations = atoi(argv[i+1]);
    } else if (param == "-divlookahead") {
      divLookahead = atoi(argv[i+1]);
    } else if (param == "-numkeep") {
      numKeep = atoi(argv[i+1]);
    } else if (param == "-divtolerance") {
      divTolerance = atof(argv[i+1]);
    } else if (param == "-greediness") {
      greediness = atoi(argv[i+1]);
    } else if (param == "-crossovertype") {
      std::string crossoverTypeString = argv[i+1];
      if (crossoverTypeString == "OB") {
        crossoverType = CrossoverType::OB;
      } else if (crossoverTypeString == "RK") {
        crossoverType = CrossoverType::RK;
      } else {
        crossoverType = CrossoverType::CX;
      }
    } else if (param == "-powerfactor") {
      float powerfactor = atof(argv[i+1]);
      mutationPower = ceil(n*powerfactor);
    }
  }


  std::cout << "ITERATION: " << 1 << std::endl;  
  rr.setOrigin();
  rr.set();
  LocalSearch localSearch1(instance1);
  localSearch1.genetic(cutoffTime, markMAX1, initPopulationSize, numCrossovers, numMutations, mutationPower, divLookahead, numKeep, divTolerance, crossoverType, greediness, opt, rr);
  if (rr.check() >= cutoffTime ) {
  return 0;
  }

  for (int i = 2; i < 10; i++) {
  std::cout << "ITERATION: " << i << std::endl;  
  std::string fileName2 = argv[i];
  Instance instance2(fileName2);
  LocalSearch localSearch2(instance2);
  localSearch2.genetic_2(cutoffTime, markMAX2, initPopulationSize, numCrossovers, numMutations, mutationPower, divLookahead, numKeep, divTolerance, crossoverType, greediness, opt, rr);
  if (rr.check() >= cutoffTime ) {
  return 0;
  }
  }


  
  std::cout << "ITERATION: " << 10 << std::endl;
  std::string fileName10 = argv[10];
  Instance instance10(fileName10);
  LocalSearch localSearch10(instance10);
  SearchResult sr = localSearch10.genetic_3(cutoffTime, initPopulationSize, numCrossovers, numMutations, mutationPower, divLookahead, numKeep, divTolerance, crossoverType, greediness, opt, rr);


} 













































