#ifndef DBSIM_H
#define DBSIM_H
#pragma warning(disable : 4996)
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <cstring>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <thread>

struct buch
{
    char autor[21];
    char titel[41];
    char verlagsname[21];
    int erscheinungsjahr;
    char erscheinungsort[41];
    char isbn[15];
};

struct index
{
    char ordnungsbegriff[21];
    int position;
};

class DBSim
{
public:
    DBSim();
    ~DBSim();
    void createIndex();
    void searchAuthor(std::string name);
    void loadFile(std::string Filename);
    void saveFile(std::string Filename);
    void sortIndexArray();
    void sortIndexArrayRevers();
    void print();
    bool noTable() { return dbTable == nullptr; }
    bool noIndex() { return indexTable == nullptr; }

protected:

private:
    std::string getLineFromTable(int i);
    index* indexTable;
    buch* dbTable;
    int dbEintraege;
    void writeStringToTable(std::string line, int index);
    void printLine(int i);
};

#endif // DBSIM_H
