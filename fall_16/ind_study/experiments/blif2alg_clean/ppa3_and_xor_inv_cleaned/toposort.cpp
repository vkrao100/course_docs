#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>
#include <stack>
#include <queue>
#include <vector>
#include <algorithm>
using namespace std;

#define MAX_VERTEX_NUM 100000

stack<int> s;
queue<int> q;
vector<int> pi;
int idxcnt = 0;

typedef struct ArcNode{
	int adjvex;
	struct ArcNode *nextarc;
	ArcNode(){nextarc=0;}
//	InfoType *info;
}ArcNode;

typedef struct VNode{
	int data;
	ArcNode *firstarc;
	VNode(){firstarc=0;}
}VNode,AdjList[MAX_VERTEX_NUM];

typedef struct{
	AdjList vertices;
	int vexnum,arcnum;
	int kind;
}ALGraph;
bool isinpi(int i)
{
	if(find(pi.begin(), pi.end(), i) == pi.end())
    	return false;
	else
   		return true;
}

// int *pi;
// int pi_num=0;
// TopologicalSort BFS
bool TopologicalSort(ALGraph G,int *indegree,string *str, string &oss)
{
	int i,k;
	int tmp;
//	ostringstream sout(oss);
	for(i=1;i<G.vexnum+1;i++)
	{
		if(!indegree[i]){q.push(i);}
	}
	int count=0;
	ArcNode *p;
	while(!q.empty())
	{
		i = q.front();
		q.pop();
		if(i==0) {continue;}
		tmp = G.vertices[i].data - 1;
//		if(tmp < 0 || tmp >= G.vexnum) {
//			cout<<"error!!!!!!!!"<<endl;
//			cout<<"error when i = "<<i<<endl;
//		}
//		idx[idxcnt] = tmp;
//		idxcnt++;
		cout<<str[tmp]<<",";
//		sout<<str[tmp]<<",";
		oss+=str[tmp];
		oss+=",";
//		cout<<G.vertices[i].data<<"-->";
		count++;
		// cout<<"\n";
		for(p=G.vertices[i].firstarc;p;p=p->nextarc)
		{
			k = p->adjvex;
			// cout<<k<<"\n";
			indegree[k]--;
			if(!indegree[k]) //q.push(k);
			{
				if (!isinpi(k))
					q.push(k);
				else
					count++;	
			}
		}
	}
	for (i = 0; i < pi.size(); ++i)
	{
		tmp = G.vertices[pi[i]].data - 1;
		cout<<str[tmp]<<",";
		oss+=str[tmp];
		oss+=",";
	}
	if(count<G.vexnum) return false;
	return true;
}


// TopologicalSort DFS
// bool TopologicalSort(ALGraph G,int *indegree,string *str, string &oss)
// {
// 	int i,k;
// //	ostringstream sout(oss);
// 	for(i=1;i<G.vexnum+1;i++)
// 	{
// 		if(!indegree[i]){s.push(i);}
// 	}
// 	int count=0;
// 	ArcNode *p;
// 	while(!s.empty())
// 	{
// 		i = s.top();
// 		s.pop();
// 		if(i==0) {continue;}
// 		int tmp;
// 		tmp = G.vertices[i].data - 1;
// //		if(tmp < 0 || tmp >= G.vexnum) {
// //			cout<<"error!!!!!!!!"<<endl;
// //			cout<<"error when i = "<<i<<endl;
// //		}
// //		idx[idxcnt] = tmp;
// //		idxcnt++;
// 		cout<<str[tmp]<<",";
// //		sout<<str[tmp]<<",";
// 		oss+=str[tmp];
// 		oss+=",";
// //		cout<<G.vertices[i].data<<"-->";
// 		count++;
// 		for(p=G.vertices[i].firstarc;p;p=p->nextarc)
// 		{
// 			k = p->adjvex;
// 			indegree[k]--;
// 			if(!indegree[k])
// 			  s.push(k);
// 		}
// 	}
// 	if(count<G.vexnum) return false;
// 	return true;
// }


int main(int argc, char *argv[])
{
	ifstream fin(argv[1]);
	ofstream fout("tmp.order");
	ofstream fanout("tmp.fanout");
	string sout;
	int i;
	ALGraph g;
//	cout<<"First line: vertex # and edge #";
	fin>>g.vexnum>>g.arcnum;
	for(i=1;i<g.vexnum+1;i++)
		g.vertices[i].data = i;

	int b,e;
	ArcNode *p;
	int *indegree = new int[g.vexnum+1];
	int *indegree_safe = new int[g.vexnum+1];

	memset(indegree,0,sizeof(int)*(g.vexnum+1));
	cout<<"Edge info (start --> end) for each line"<<endl;
	for(i=1;i<g.arcnum+1;i++)
	{
		// cout<<"No."<<i<<"edge: ";
		fin>>b>>e;
		p = new ArcNode();
		p->adjvex = e;
		p->nextarc = g.vertices[b].firstarc;
		g.vertices[b].firstarc = p;
		indegree[e]++;
		indegree_safe[e]++;
//		cout<<endl;
	}

	for (i = 1; i < g.vexnum+1; ++i)
	{
		if(g.vertices[i].firstarc == 0)
			pi.push_back(i);	

	}
	// cout<<pi.size()<<"\n";
	// pi = new int[pi_num];
	
	string *vname = new string[g.vexnum+1];
	for(i=0;i<g.vexnum;i++)
	{
		fin>>vname[i];
//		cout<<vname[i]<<" ";
	}
//	cout<<endl;

//	int *idx = new int[g.vexnum+1];
//	memset(idx,0,sizeof(int)*(g.vexnum+1));

	if(TopologicalSort(g,indegree,vname,sout)) 
		cout<<"No news is good news!"<<endl;
	else cout<<"Error: Loop detected!"<<endl;
	
	if(sout.size() > 0)
		sout.resize(sout.size()-1);
	fout<<sout;
	int flag=0;
	for (i = 1; i < g.vexnum+1; ++i)
	{
		// cout<<"i = "<<i<<" InDegree = "<<indegree_safe[i]<<"\n";
		if(indegree_safe[i] > 1)
		{
			fanout<<vname[i-1]<<",";
		}
	}

//	for(i=0;i<g.vexnum;i++){
//		cout<<idx[i]<<" ";
//	}
//	cout<<endl;
	fin.close();
	fout.close();
	fanout.close();
	return 0;
}
