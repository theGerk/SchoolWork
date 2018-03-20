
//original (with x and y disconnected)
const ADJ_LIST = [
	[], //a 0
	[], //b 1
	[1], //c 2
	[1], //d 3
	[0, 1], //e 4
	[0], //f 5
	[], //x 6
	[]		//y 7
];
var opt1 = JSON.parse(JSON.stringify(ADJ_LIST));
opt1[7].push(6);
var opt2 = JSON.parse(JSON.stringify(ADJ_LIST));
opt2[7].push(0, 1, 6);

// function convertAdjListToMatrix(adj)
// {
// 	var size = adj.length;
// 	var output = [];
// 	for(var i = 0; i < size; i++)
// 	{
// 		var current = [];
// 		current.length = size;
// 		current.fill(false);
// 		for(var j of adj[i])
// 		{
// 			current[j] = true;
// 		}
// 		output.push(current);
// 	}
// 	return output;
// }

function normalize(arr)
{
	var sum = arr.reduce((a, b) => a + b);
	if (sum === 0)
		return arr;
	else
		return arr.map(a => a / sum);
}

function authority(adj, hubScore)
{
	var output = [];
	output.length = hubScore.length;
	output.fill(0);
	for (var i = 0; i < hubScore.length; i++)
	{
		for (var v of adj[i])
		{
			output[v] += hubScore[i];
		}
	}
	return normalize(output);
}

function hub(adj, authorityScore)
{
	var output = [];
	output.length = authorityScore.length;
	output.fill(0);
	for (var i = 0; i < authorityScore.length; i++)
	{
		for (var v of adj[i])
		{
			output[i] += authorityScore[v];
		}
	}
	return normalize(output);
}


function simulate(graph, steps)
{
	var hubs = [];
	var authorities = [];
	hubs.length = authorities.length = graph.length;
	hubs.fill(1 / hubs.length);
	authorities.fill(1 / authorities.length);

	console.log('\\begin{center}');
	console.log("\\begin{tabular}{c|" + (function (c) {
		var output = 'c';
		while (c > 1) {
			c--;
			output += '|c';
		}
		return output;
	})(graph.length) + '}');

	console.log('name & a & b & c & d & e & f & x & y \\\\');
	console.log('\\hline');

	//step 0
	console.log('Authorities 0 & ' + authorities.join(' & ') + ' \\\\');
	console.log('Hubs        0 & ' + hubs.join(' & ') + ' \\\\');
	for (var i = 1; i <= steps; i++)
	{
		authorities = authority(graph, hubs);
		console.log('Authorities ' + i + ' & ' + authorities.map(x => x.toFixed(4)).join(' & ') + ' \\\\');
		hubs = hub(graph, authorities);
		console.log('Hubs        ' + i + ' & ' + hubs.map(x => x.toFixed(4)).join(' & ') + ' \\\\');
	}
	console.log('\\end{tabular}');
	console.log('\\end{center}');
}

console.log('\\documentclass{article}');
console.log('\\input{../../definitions.tex}');
console.log('\\begin{document}');
console.log('All values are rounded to 4 decimal places, so that the readout is not to long.\n');
simulate(opt1, 2);
console.log('\\bigskip\n');
simulate(opt2, 2);
console.log('\\end{document}');
