#include "resultregister.h"
#include <fstream>
#include <sstream>
#include "debug.h"
#include <climits>
#include <iomanip>

ResultRegister::ResultRegister() : origin(0), checkOrigin(0), bestScore(LLONG_MAX), scores(0), bestScores(0), bestOrderings(0) {
  set();
}

void ResultRegister::record(Types::Score score, const Ordering &o) {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  long int curMill = tp.tv_sec * 1000 + tp.tv_usec / 1000;
  //long int curMill = tp.tv_sec + tp.tv_usec / 1000;
  if (score < bestScore) {
    bestScore = score;
    bestScores.push_back(std::make_pair(curMill - origin, score));
    std::stringstream ss;
    ss << o;
    bestOrderings.push_back(ss.str());
  }
}

float ResultRegister::check() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  long int curMill = tp.tv_sec * 1000 + tp.tv_usec / 1000;
  //long int curMill = tp.tv_sec + tp.tv_usec / 1000;
  return ((double)curMill - (double)checkOrigin)/(float)1000;
  //return ((double)curMill - (double)checkOrigin)/(float)1000;
}

void ResultRegister::set() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  long int curMill = tp.tv_sec * 1000 + tp.tv_usec / 1000;
  //long int curMill = tp.tv_sec + tp.tv_usec / 1000;
  origin = curMill;
}

void ResultRegister::setOrigin() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  long int curMill = tp.tv_sec * 1000 + tp.tv_usec / 1000;
  //long int curMill = tp.tv_sec + tp.tv_usec / 1000;
  checkOrigin = curMill;
}

void ResultRegister::dump(const std::string &outFile) {
  std::ofstream os(outFile);
  write(os);
}

void ResultRegister::dump(const std::string &outFile, const std::string &instanceTitle) {
  std::ofstream os(outFile);
  os << instanceTitle << std::endl;
  write(os);
}

void ResultRegister::dump(const std::string &outFile, const std::string &instanceTitle, int argc, char* argv[], const SearchResult &sr) {
  std::ofstream os(outFile);
  os << instanceTitle << std::endl;
  for (int i = 1; i < argc; i++) {
    os << argv[i] << std::endl;
  }
  write(os);
}


void ResultRegister::write(std::ofstream &os) {
  os << "BEST" << std::endl;
  os << "Time \tScore, followed by ordering next line" << std::endl;
  int nBest = bestScores.size();
  for (int i = 0; i < nBest; i++) {
    os << std::fixed << std::setprecision(6)<< bestScores[i].first /(float)1000 << "\t" << bestScores[i].second /(float)-1000000 << std::endl;
    //os << bestOrderings[i] << std::endl;
  }
}

Types::Score ResultRegister::getBest() {
  if (scores.size() < 1) {
    return LLONG_MAX;
  }
  return bestScore;
}

