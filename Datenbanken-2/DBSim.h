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
#include <iomanip>
#include <functional>
#include <memory_resource>
#include <unordered_set>

using  std::string;

struct buch
{
    char autor[21];
    char titel[41];
    char verlagsname[21];
    char erscheinungsjahr[4];
    char erscheinungsort[41];
    char isbn[15];
};

struct index
{
    char ordnungsbegriff[21];
    int position;
};

struct MyHash
{
    std::size_t operator()(buch const& b) const noexcept
    {
        std::size_t h1 = std::hash<std::string>{}(b.autor);
        std::size_t h2 = std::hash<std::string>{}(b.titel);
        std::size_t h3 = std::hash<std::string>{}(b.verlagsname);
        std::size_t h4 = std::hash<std::string>{}(b.erscheinungsjahr);
        std::size_t h5 = std::hash<std::string>{}(b.erscheinungsort);
        std::size_t h6 = std::hash<std::string>{}(b.isbn);
        return h1 ^ (h2 << 1) ^ (h3 << 2); // or use boost::hash_combine
    }
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
    void hashspeicherung();
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
