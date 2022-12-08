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
using namespace std;

struct buch
{
    char autor[40];
    char titel[200];
    char verlagsname[21];
    int erscheinungsjahr;
    char erscheinungsort[41];
    char isbn[15];
    int key;
};

struct index
{
    char ordnungsbegriff[21];
    struct block* address;
    int position;
};

struct block
{
    buch data[5];
    block* overflowBlock;
    int n;
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
    void print();
    void printStructure();
    void sucheKey(int key);
    int hashBerechnen(int n);
    void ausgabeDaten(block* curr, int n);
    void ausgabeTitel();
    void datensatzInDatenarray(std::string line);
    int getHash(int);
    bool noTable() { return dbEntries < 0; }
    bool noIndex() { return indexTable == nullptr; }
    int getSize() { return dbEntries; }

protected:

private:
    index* indexTable;
    block* blockarray;
    int dbEntries;

    void clearOFBlocks(struct block*);
    void clearTable();

    std::string getLineFromTable(block*, int);
    void writeStringToTable(std::string line);
    void printLine(block*, int);

};

#endif // DBSIM_H
