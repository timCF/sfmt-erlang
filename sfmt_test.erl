%% Module sfmt_test (testing sfmt module)

%% Copyright (c) 2010 Kenji Rikitake. All rights reserved.
%%
%% Copyright (c) 2006,2007 Mutsuo Saito, Makoto Matsumoto and Hiroshima
%% University. All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following conditions are
%% met:
%%
%%     * Redistributions of source code must retain the above copyright
%%       notice, this list of conditions and the following disclaimer.
%%     * Redistributions in binary form must reproduce the above
%%       copyright notice, this list of conditions and the following
%%       disclaimer in the documentation and/or other materials provided
%%       with the distribution.
%%     * Neither the name of the Hiroshima University nor the names of
%%       its contributors may be used to endorse or promote products
%%       derived from this software without specific prior written
%%       permission.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-module(sfmt_test).

-export([
	 test_speed_rand/2,
	 test/0
	 ]).

test_rec1(0, Acc, Randlist, Int) ->
    {lists:reverse(Acc), Randlist, Int};
test_rec1(I, Acc, Randlist, Int) ->
    {Val, Randlist2, Int2} = sfmt:gen_rand32(Randlist, Int),
    test_rec1(I - 1, [Val | Acc], Randlist2, Int2).

test_sfmt_check() ->
    {Refrand, Refarray} = test_refval(),
    Int1 = sfmt:init_gen_rand(1234),
    {Outarray1, Int2} = sfmt:gen_rand_list32(10000, Int1),
    {Outarray2, _Int3} = sfmt:gen_rand_list32(10000, Int2),
    case Refrand =/= lists:reverse(
		       lists:nthtail(10000 - length(Refrand),
				     lists:reverse(Outarray1))) of
	true ->
	    erlang:error({error_Refrand_Outarray1_testfailed});
	false ->
	    io:format("Refrand to Outarray1 test passed~n", [])
    end,
    Int4 = sfmt:init_gen_rand(1234),
    {Outarray3, Randlist5, Int5} = test_rec1(10000, [], [], Int4),
    case Outarray3 =/= Outarray1 of
	true ->
	    erlang:error({error_Outarray3_Outarray1_testfailed});
	false ->
	    io:format("Outarray3 to Outarray1 test passed~n", [])
    end,
    {Outarray4, _Randlist6, _Int6} = test_rec1(10000, [], Randlist5, Int5),
    case Outarray4 =/= Outarray2 of
	true ->
	    erlang:error({error_Outarray4_Outarray2_testfailed});
	false ->
	    io:format("Outarray4 to Outarray2 test passed~n", [])
    end,
    Int7 = sfmt:init_by_list32([16#1234, 16#5678, 16#9abc, 16#def0]),
    {Outarray5, Int8} = sfmt:gen_rand_list32(10000, Int7),
    {Outarray6, _Int9} = sfmt:gen_rand_list32(10000, Int8),
    case Refarray =/= lists:reverse(
		       lists:nthtail(10000 - length(Refarray),
				     lists:reverse(Outarray5))) of
	true ->
	    erlang:error({error_Refarray_Outarray5_testfailed});
	false ->
	    io:format("Refarray to Outarray5 test passed~n", [])
    end,
    Int10 = sfmt:init_by_list32([16#1234, 16#5678, 16#9abc, 16#def0]),
    {Outarray7, Randlist11, Int11} = test_rec1(10000, [], [], Int10),
    case Outarray7 =/= Outarray5 of
	true ->
	    erlang:error({error_Outarray7_Outarray5_testfailed});
	false ->
	    io:format("Outarray7 to Outarray5 test passed~n", [])
    end,
    {Outarray8, _Randlist12, _Int12} = test_rec1(10000, [], Randlist11, Int11),
    case Outarray8 =/= Outarray6 of
	true ->
	    erlang:error({error_Outarray8_Outarray6_testfailed});
	false ->
	    io:format("Outarray8 to Outarray6 test passed~n", [])
    end.

test_speed_rand_rec1(0, _, _) ->
    ok;
test_speed_rand_rec1(X, Q, I) ->
    {_, I2} = sfmt:gen_rand_list32(Q, I),
    test_speed_rand_rec1(X - 1, Q, I2).

test_speed_rand(P, Q) ->
    I = sfmt:init_gen_rand(1234),
    ok = test_speed_rand_rec1(P, Q, I).

test_speed_timer() -> 
    timer:tc(?MODULE, test_speed_rand, [100, 100000]).

test_speed() ->
    io:format("100 * sfmt:gen_rand_list32(100000, i)~n~p~n",
	      [test_speed_timer()]).

test() ->
    test_sfmt_check(),
    test_speed().

test_refval() ->
    %% values taken from SFMT.19937.out.txt of SFMT-1.3.3
    Refrand = [
	      3440181298,1564997079,1510669302,2930277156,1452439940,
	      3796268453,423124208,2143818589,3827219408,2987036003,
	      2674978610,1536842514,2027035537,2534897563,1686527725,
	      545368292,1489013321,1370534252,4231012796,3994803019,
	      1764869045,824597505,862581900,2469764249,812862514,
	      359318673,116957936,3367389672,2327178354,1898245200,
	      3206507879,2378925033,1040214787,2524778605,3088428700,
	      1417665896,964324147,2282797708,2456269299,313400376,
	      2245093271,1015729427,2694465011,3246975184,1992793635,
	      463679346,3721104591,3475064196,856141236,1499559719,
	      3522818941,3721533109,1954826617,1282044024,1543279136,
	      1301863085,2669145051,4221477354,3896016841,3392740262,
	      462466863,1037679449,1228140306,922298197,1205109853,
	      1872938061,3102547608,2742766808,1888626088,4028039414,
	      157593879,1136901695,4038377686,3572517236,4231706728,
	      2997311961,1189931652,3981543765,2826166703,87159245,
	      1721379072,3897926942,1790395498,2569178939,1047368729,
	      2340259131,3144212906,2301169789,2442885464,3034046771,
	      3667880593,3935928400,2372805237,1666397115,2460584504,
	      513866770,3810869743,2147400037,2792078025,2941761810,
	      3212265810,984692259,346590253,1804179199,3298543443,
	      750108141,2880257022,243310542,1869036465,1588062513,
	      2983949551,1931450364,4034505847,2735030199,1628461061,
	      2539522841,127965585,3992448871,913388237,559130076,
	      1202933193,4087643167,2590021067,2256240196,1746697293,
	      1013913783,1155864921,2715773730,915061862,1948766573,
	      2322882854,3761119102,1343405684,3078711943,3067431651,
	      3245156316,3588354584,3484623306,3899621563,4156689741,
	      3237090058,3880063844,862416318,4039923869,2303788317,
	      3073590536,701653667,2131530884,3169309950,2028486980,
	      747196777,3620218225,432016035,1449580595,2772266392,
	      444224948,1662832057,3184055582,3028331792,1861686254,
	      1104864179,342430307,1350510923,3024656237,1028417492,
	      2870772950,290847558,3675663500,508431529,4264340390,
	      2263569913,1669302976,519511383,2706411211,3764615828,
	      3883162495,4051445305,2412729798,3299405164,3991911166,
	      2348767304,2664054906,3763609282,593943581,3757090046,
	      2075338894,2020550814,4287452920,4290140003,1422957317,
	      2512716667,2003485045,2307520103,2288472169,3940751663,
	      4204638664,2892583423,1710068300,3904755993,2363243951,
	      3038334120,547099465,771105860,3199983734,4282046461,
	      2298388363,934810218,2837827901,3952500708,2095130248,
	      3083335297,26885281,3932155283,1531751116,1425227133,
	      495654159,3279634176,3855562207,3957195338,4159985527,
	      893375062,1875515536,1327247422,3754140693,1028923197,
	      1729880440,805571298,448971099,2726757106,2749436461,
	      2485987104,175337042,3235477922,3882114302,2020970972,
	      943926109,2762587195,1904195558,3452650564,108432281,
	      3893463573,3977583081,2636504348,1110673525,3548479841,
	      4258854744,980047703,4057175418,3890008292,145653646,
	      3141868989,3293216228,1194331837,1254570642,3049934521,
	      2868313360,2886032750,1110873820,279553524,3007258565,
	      1104807822,3186961098,315764646,2163680838,3574508994,
	      3099755655,191957684,3642656737,3317946149,3522087636,
	      444526410,779157624,1088229627,1092460223,1856013765,
	      3659877367,368270451,503570716,3000984671,2742789647,
	      928097709,2914109539,308843566,2816161253,3667192079,
	      2762679057,3395240989,2928925038,1491465914,3458702834,
	      3787782576,2894104823,1296880455,1253636503,989959407,
	      2291560361,2776790436,1913178042,1584677829,689637520,
	      1898406878,688391508,3385234998,845493284,1943591856,
	      2720472050,222695101,1653320868,2904632120,4084936008,
	      1080720688,3938032556,387896427,2650839632,99042991,
	      1720913794,1047186003,1877048040,2090457659,517087501,
	      4172014665,2129713163,2413533132,2760285054,4129272496,
	      1317737175,2309566414,2228873332,3889671280,1110864630,
	      3576797776,2074552772,832002644,3097122623,2464859298,
	      2679603822,1667489885,3237652716,1478413938,1719340335,
	      2306631119,639727358,3369698270,226902796,2099920751,
	      1892289957,2201594097,3508197013,3495811856,3900381493,
	      841660320,3974501451,3360949056,1676829340,728899254,
	      2047809627,2390948962,670165943,3412951831,4189320049,
	      1911595255,2055363086,507170575,418219594,4141495280,
	      2692088692,4203630654,3540093932,791986533,2237921051,
	      2526864324,2956616642,1394958700,1983768223,1893373266,
	      591653646,228432437,1611046598,3007736357,1040040725,
	      2726180733,2789804360,4263568405,829098158,3847722805,
	      1123578029,1804276347,997971319,4203797076,4185199713,
	      2811733626,2343642194,2985262313,1417930827,3759587724,
	      1967077982,1585223204,1097475516,1903944948,740382444,
	      1114142065,1541796065,1718384172,1544076191,1134682254,
	      3519754455,2866243923,341865437,645498576,2690735853,
	      1046963033,2493178460,1187604696,1619577821,488503634,
	      3255768161,2306666149,1630514044,2377698367,2751503746,
	      3794467088,1796415981,3657173746,409136296,1387122342,
	      1297726519,219544855,4270285558,437578827,1444698679,
	      2258519491,963109892,3982244073,3351535275,385328496,
	      1804784013,698059346,3920535147,708331212,784338163,
	      785678147,1238376158,1557298846,2037809321,271576218,
	      4145155269,1913481602,2763691931,588981080,1201098051,
	      3717640232,1509206239,662536967,3180523616,1133105435,
	      2963500837,2253971215,3153642623,1066925709,2582781958,
	      3034720222,1090798544,2942170004,4036187520,686972531,
	      2610990302,2641437026,1837562420,722096247,1315333033,
	      2102231203,3402389208,3403698140,1312402831,2898426558,
	      814384596,385649582,1916643285,1924625106,2512905582,
	      2501170304,4275223366,2841225246,1467663688,3563567847,
	      2969208552,884750901,102992576,227844301,3681442994,
	      3502881894,4034693299,1166727018,1697460687,1737778332,
	      1787161139,1053003655,1215024478,2791616766,2525841204,
	      1629323443,3233815,2003823032,3083834263,2379264872,
	      3752392312,1287475550,3770904171,3004244617,1502117784,
	      918698423,2419857538,3864502062,1751322107,2188775056,
	      4018728324,983712955,440071928,3710838677,2001027698,
	      3994702151,22493119,3584400918,3446253670,4254789085,
	      1405447860,1240245579,1800644159,1661363424,3278326132,
	      3403623451,67092802,2609352193,3914150340,1814842761,
	      3610830847,591531412,3880232807,1673505890,2585326991,
	      1678544474,3148435887,3457217359,1193226330,2816576908,
	      154025329,121678860,1164915738,973873761,269116100,
	      52087970,744015362,498556057,94298882,1563271621,
	      2383059628,4197367290,3958472990,2592083636,2906408439,
	      1097742433,3924840517,264557272,2292287003,3203307984,
	      4047038857,3820609705,2333416067,1839206046,3600944252,
	      3412254904,583538222,2390557166,4140459427,2810357445,
	      226777499,2496151295,2207301712,3283683112,611630281,
	      1933218215,3315610954,3889441987,3719454256,3957190521,
	      1313998161,2365383016,3146941060,1801206260,796124080,
	      2076248581,1747472464,3254365145,595543130,3573909503,
	      3758250204,2020768540,2439254210,93368951,3155792250,
	      2600232980,3709198295,3894900440,2971850836,1578909644,
	      1443493395,2581621665,3086506297,2443465861,558107211,
	      1519367835,249149686,908102264,2588765675,1232743965,
	      1001330373,3561331654,2259301289,1564977624,3835077093,
	      727244906,4255738067,1214133513,2570786021,3899704621,
	      1633861986,1636979509,1438500431,58463278,2823485629,
	      2297430187,2926781924,3371352948,1864009023,2722267973,
	      1444292075,437703973,1060414512,189705863,910018135,
	      4077357964,884213423,2644986052,3973488374,1187906116,
	      2331207875,780463700,3713351662,3854611290,412805574,
	      2978462572,2176222820,829424696,2790788332,2750819108,
	      1594611657,3899878394,3032870364,1702887682,1948167778,
	      14130042,192292500,947227076,90719497,3854230320,
	      784028434,2142399787,1563449646,2844400217,819143172,
	      2883302356,2328055304,1328532246,2603885363,3375188924,
	      933941291,3627039714,2129697284,2167253953,2506905438,
	      1412424497,2981395985,1418359660,2925902456,52752784,
	      3713667988,3924669405,648975707,1145520213,4018650664,
	      3805915440,2380542088,2013260958,3262572197,2465078101,
	      1114540067,3728768081,2396958768,590672271,904818725,
	      4263660715,700754408,1042601829,4094111823,4274838909,
	      2512692617,2774300207,2057306915,3470942453,99333088,
	      1142661026,2889931380,14316674,2201179167,415289459,
	      448265759,3515142743,3254903683,246633281,1184307224,
	      2418347830,2092967314,2682072314,2558750234,2000352263,
	      1544150531,399010405,1513946097,499682937,461167460,
	      3045570638,1633669705,851492362,4052801922,2055266765,
	      635556996,368266356,2385737383,3218202352,2603772408,
	      349178792,226482567,3102426060,3575998268,2103001871,
	      3243137071,225500688,1634718593,4283311431,4292122923,
	      3842802787,811735523,105712518,663434053,1855889273,
	      2847972595,1196355421,2552150115,4254510614,3752181265,
	      3430721819,3828705396,3436287905,3441964937,4123670631,
	      353001539,459496439,3799690868,1293777660,2761079737,
	      498096339,3398433374,4080378380,2304691596,2995729055,
	      4134660419,3903444024,3576494993,203682175,3321164857,
	      2747963611,79749085,2992890370,1240278549,1772175713,
	      2111331972,2655023449,1683896345,2836027212,3482868021,
	      2489884874,756853961,2298874501,4013448667,4143996022,
	      2948306858,4132920035,1283299272,995592228,3450508595,
	      1027845759,1766942720,3861411826,1446861231,95974993,
	      3502263554,1487532194,601502472,4129619129,250131773,
	      2050079547,3198903947,3105589778,4066481316,3026383978,
	      2276901713,365637751,2260718426,1394775634,1791172338,
	      2690503163,2952737846,1568710462,732623190,2980358000,
	      1053631832,1432426951,3229149635,1854113985,3719733532,
	      3204031934,735775531,107468620,3734611984,631009402,
	      3083622457,4109580626,159373458,1301970201,4132389302,
	      1293255004,847182752,4170022737,96712900,2641406755,
	      1381727755,405608287,4287919625,1703554290,3589580244,
	      2911403488,2166565,2647306451,2330535117,1200815358,
	      1165916754,245060911,4040679071,3684908771,2452834126,
	      2486872773,2318678365,2940627908,1837837240,3447897409,
	      4270484676,1495388728,3754288477,4204167884,1386977705,
	      2692224733,3076249689,4109568048,4170955115,4167531356,
	      4020189950,4261855038,3036907575,3410399885,3076395737,
	      1046178638,144496770,230725846,3349637149,17065717,
	      2809932048,2054581785,3608424964,3259628808,134897388,
	      3743067463,257685904,3795656590,1562468719,3589103904,
	      3120404710,254684547,2653661580,3663904795,2631942758,
	      1063234347,2609732900,2332080715,3521125233,1180599599,
	      1935868586,4110970440,296706371,2128666368,1319875791,
	      1570900197,3096025483,1799882517,1928302007,1163707758,
	      1244491489,3533770203,567496053,2757924305,2781639343,
	      2818420107,560404889,2619609724,4176035430,2511289753,
	      2521842019,3910553502,2926149387,3302078172,4237118867,
	      330725126,367400677,888239854,545570454,4259590525,
	      134343617,1102169784,1647463719,3260979784,1518840883,
	      3631537963,3342671457,1301549147,2083739356,146593792,
	      3217959080,652755743,2032187193,3898758414,1021358093,
	      4037409230,2176407931,3427391950,2883553603,985613827,
	      3105265092,3423168427,3387507672,467170288,2141266163,
	      3723870208,916410914,1293987799,2652584950,769160137,
	      3205292896,1561287359,1684510084,3136055621,3765171391,
	      639683232,2639569327,1218546948,4263586685,3058215773,
	      2352279820,401870217,2625822463,1529125296,2981801895,
	      1191285226,4027725437,3432700217,4098835661,971182783,
	      2443861173,3881457123,3874386651,457276199,2638294160,
	      4002809368,421169044,1112642589,3076213779,3387033971,
	      2499610950,3057240914,1662679783,461224431,1168395933
	     ],
    Refarray =
	[
	 2920711183,3885745737,3501893680,856470934,1421864068,
	 277361036,1518638004,2328404353,3355513634,64329189,
	 1624587673,3508467182,2481792141,3706480799,1925859037,
	 2913275699,882658412,384641219,422202002,1873384891,
	 2006084383,3924929912,1636718106,3108838742,1245465724,
	 4195470535,779207191,1577721373,1390469554,2928648150,
	 121399709,3170839019,4044347501,953953814,3821710850,
	 3085591323,3666535579,3577837737,2012008410,3565417471,
	 4044408017,433600965,1637785608,1798509764,860770589,
	 3081466273,3982393409,2451928325,3437124742,4093828739,
	 3357389386,2154596123,496568176,2650035164,2472361850,
	 3438299,2150366101,1577256676,3802546413,1787774626,
	 4078331588,3706103141,170391138,3806085154,1680970100,
	 1961637521,3316029766,890610272,1453751581,1430283664,
	 3051057411,3597003186,542563954,3796490244,1690016688,
	 3448752238,440702173,347290497,1121336647,2540588620,
	 280881896,2495136428,213707396,15104824,2946180358,
	 659000016,566379385,2614030979,2855760170,334526548,
	 2315569495,2729518615,564745877,1263517638,3157185798,
	 1604852056,1011639885,2950579535,2524219188,312951012,
	 1528896652,1327861054,2846910138,3966855905,2536721582,
	 855353911,1685434729,3303978929,1624872055,4020329649,
	 3164802143,1642802700,1957727869,1792352426,3334618929,
	 2631577923,3027156164,842334259,3353446843,1226432104,
	 1742801369,3552852535,3471698828,1653910186,3380330939,
	 2313782701,3351007196,2129839995,1800682418,4085884420,
	 1625156629,3669701987,615211810,3294791649,4131143784,
	 2590843588,3207422808,3275066464,561592872,3957205738,
	 3396578098,48410678,3505556445,1005764855,3920606528,
	 2936980473,2378918600,2404449845,1649515163,701203563,
	 3705256349,83714199,3586854132,922978446,2863406304,
	 3523398907,2606864832,2385399361,3171757816,4262841009,
	 3645837721,1169579486,3666433897,3174689479,1457866976,
	 3803895110,3346639145,1907224409,1978473712,1036712794,
	 980754888,1302782359,1765252468,459245755,3728923860,
	 1512894209,2046491914,207860527,514188684,2288713615,
	 1597354672,3349636117,2357291114,3995796221,945364213,
	 1893326518,3770814016,1691552714,2397527410,967486361,
	 776416472,4197661421,951150819,1852770983,4044624181,
	 1399439738,4194455275,2284037669,1550734958,3321078108,
	 1865235926,2912129961,2664980877,1357572033,2600196436,
	 2486728200,2372668724,1567316966,2374111491,1839843570,
	 20815612,3727008608,3871996229,824061249,1932503978,
	 3404541726,758428924,2609331364,1223966026,1299179808,
	 648499352,2180134401,880821170,3781130950,113491270,
	 1032413764,4185884695,2490396037,1201932817,4060951446,
	 4165586898,1629813212,2887821158,415045333,628926856,
	 2193466079,3391843445,2227540681,1907099846,2848448395,
	 1717828221,1372704537,1707549841,2294058813,2101214437,
	 2052479531,1695809164,3176587306,2632770465,81634404,
	 1603220563,644238487,302857763,897352968,2613146653,
	 1391730149,4245717312,4191828749,1948492526,2618174230,
	 3992984522,2178852787,3596044509,3445573503,2026614616,
	 915763564,3415689334,2532153403,3879661562,2215027417,
	 3111154986,2929478371,668346391,1152241381,2632029711,
	 3004150659,2135025926,948690501,2799119116,4228829406,
	 1981197489,4209064138,684318751,3459397845,201790843,
	 4022541136,3043635877,492509624,3263466772,1509148086,
	 921459029,3198857146,705479721,3835966910,3603356465,
	 576159741,1742849431,594214882,2055294343,3634861861,
	 449571793,3246390646,3868232151,1479156585,2900125656,
	 2464815318,3960178104,1784261920,18311476,3627135050,
	 644609697,424968996,919890700,2986824110,816423214,
	 4003562844,1392714305,1757384428,2569030598,995949559,
	 3875659880,2933807823,2752536860,2993858466,4030558899,
	 2770783427,2775406005,2777781742,1931292655,472147933,
	 3865853827,2726470545,2668412860,2887008249,408979190,
	 3578063323,3242082049,1778193530,27981909,2362826515,
	 389875677,1043878156,581653903,3830568952,389535942,
	 3713523185,2768373359,2526101582,1998618197,1160859704,
	 3951172488,1098005003,906275699,3446228002,2220677963,
	 2059306445,132199571,476838790,1868039399,3097344807,
	 857300945,396345050,2835919916,1782168828,1419519470,
	 4288137521,819087232,596301494,872823172,1526888217,
	 805161465,1116186205,2829002754,2352620120,620121516,
	 354159268,3601949785,209568138,1352371732,2145977349,
	 4236871834,1539414078,3558126206,3224857093,4164166682,
	 3817553440,3301780278,2682696837,3734994768,1370950260,
	 1477421202,2521315749,1330148125,1261554731,2769143688,
	 3554756293,4235882678,3254686059,3530579953,1215452615,
	 3574970923,4057131421,589224178,1000098193,171190718,
	 2521852045,2351447494,2284441580,2646685513,3486933563,
	 3789864960,1190528160,1702536782,1534105589,4262946827,
	 2726686826,3584544841,2348270128,2145092281,2502718509,
	 1027832411,3571171153,1287361161,4011474411,3241215351,
	 2419700818,971242709,1361975763,1096842482,3271045537,
	 81165449,612438025,3912966678,1356929810,733545735,
	 537003843,1282953084,884458241,588930090,3930269801,
	 2961472450,1219535534,3632251943,268183903,1441240533,
	 3653903360,3854473319,2259087390,2548293048,2022641195,
	 2105543911,1764085217,3246183186,482438805,888317895,
	 2628314765,2466219854,717546004,2322237039,416725234,
	 1544049923,1797944973,3398652364,3111909456,485742908,
	 2277491072,1056355088,3181001278,129695079,2693624550,
	 1764438564,3797785470,195503713,3266519725,2053389444,
	 1961527818,3400226523,3777903038,2597274307,4235851091,
	 4094406648,2171410785,1781151386,1378577117,654643266,
	 3424024173,3385813322,679385799,479380913,681715441,
	 3096225905,276813409,3854398070,2721105350,831263315,
	 3276280337,2628301522,3984868494,1466099834,2104922114,
	 1412672743,820330404,3491501010,942735832,710652807,
	 3972652090,679881088,40577009,3705286397,2815423480,
	 3566262429,663396513,3777887429,4016670678,404539370,
	 1142712925,1140173408,2913248352,2872321286,263751841,
	 3175196073,3162557581,2878996619,75498548,3836833140,
	 3284664959,1157523805,112847376,207855609,1337979698,
	 1222578451,157107174,901174378,3883717063,1618632639,
	 1767889440,4264698824,1582999313,884471997,2508825098,
	 3756370771,2457213553,3565776881,3709583214,915609601,
	 460833524,1091049576,85522880,2553251,132102809,
	 2429882442,2562084610,1386507633,4112471229,21965213,
	 1981516006,2418435617,3054872091,4251511224,2025783543,
	 1916911512,2454491136,3938440891,3825869115,1121698605,
	 3463052265,802340101,1912886800,4031997367,3550640406,
	 1596096923,610150600,431464457,2541325046,486478003,
	 739704936,2862696430,3037903166,1129749694,2611481261,
	 1228993498,510075548,3424962587,2458689681,818934833,
	 4233309125,1608196251,3419476016,1858543939,2682166524,
	 3317854285,631986188,3008214764,613826412,3567358221,
	 3512343882,1552467474,3316162670,1275841024,4142173454,
	 565267881,768644821,198310105,2396688616,1837659011,
	 203429334,854539004,4235811518,3338304926,3730418692,
	 3852254981,3032046452,2329811860,2303590566,2696092212,
	 3894665932,145835667,249563655,1932210840,2431696407,
	 3312636759,214962629,2092026914,3020145527,4073039873,
	 2739105705,1308336752,855104522,2391715321,67448785,
	 547989482,854411802,3608633740,431731530,537375589,
	 3888005760,696099141,397343236,1864511780,44029739,
	 1729526891,1993398655,2010173426,2591546756,275223291,
	 1503900299,4217765081,2185635252,1122436015,3550155364,
	 681707194,3260479338,933579397,2983029282,2505504587,
	 2667410393,2962684490,4139721708,2658172284,2452602383,
	 2607631612,1344296217,3075398709,2949785295,1049956168,
	 3917185129,2155660174,3280524475,1503827867,674380765,
	 1918468193,3843983676,634358221,2538335643,1873351298,
	 3368723763,2129144130,3203528633,3087174986,2691698871,
	 2516284287,24437745,1118381474,2816314867,2448576035,
	 4281989654,217287825,165872888,2628995722,3533525116,
	 2721669106,872340568,3429930655,3309047304,3916704967,
	 3270160355,1348884255,1634797670,881214967,4259633554,
	 174613027,1103974314,1625224232,2678368291,1133866707,
	 3853082619,4073196549,1189620777,637238656,930241537,
	 4042750792,3842136042,2417007212,2524907510,1243036827,
	 1282059441,3764588774,1394459615,2323620015,1166152231,
	 3307479609,3849322257,3507445699,4247696636,758393720,
	 967665141,1095244571,1319812152,407678762,2640605208,
	 2170766134,3663594275,4039329364,2512175520,725523154,
	 2249807004,3312617979,2414634172,1278482215,349206484,
	 1573063308,1196429124,3873264116,2400067801,268795167,
	 226175489,2961367263,1968719665,42656370,1010790699,
	 561600615,2422453992,3082197735,1636700484,3977715296,
	 3125350482,3478021514,2227819446,1540868045,3061908980,
	 1087362407,3625200291,361937537,580441897,1520043666,
	 2270875402,1009161260,2502355842,4278769785,473902412,
	 1057239083,1905829039,1483781177,2080011417,1207494246,
	 1806991954,2194674403,3455972205,807207678,3655655687,
	 674112918,195425752,3917890095,1874364234,1837892715,
	 3663478166,1548892014,2570748714,2049929836,2167029704,
	 697543767,3499545023,3342496315,1725251190,3561387469,
	 2905606616,1580182447,3934525927,4103172792,1365672522,
	 1534795737,3308667416,2841911405,3943182730,4072020313,
	 3494770452,3332626671,55327267,478030603,411080625,
	 3419529010,1604767823,3513468014,570668510,913790824,
	 2283967995,695159462,3825542932,4150698144,1829758699,
	 202895590,1609122645,1267651008,2910315509,2511475445,
	 2477423819,3932081579,900879979,2145588390,2670007504,
	 580819444,1864996828,2526325979,1019124258,815508628,
	 2765933989,1277301341,3006021786,855540956,288025710,
	 1919594237,2331223864,177452412,2475870369,2689291749,
	 865194284,253432152,2628531804,2861208555,2361597573,
	 1653952120,1039661024,2159959078,3709040440,3564718533,
	 2596878672,2041442161,31164696,2662962485,3665637339,
	 1678115244,2699839832,3651968520,3521595541,458433303,
	 2423096824,21831741,380011703,2498168716,861806087,
	 1673574843,4188794405,2520563651,2632279153,2170465525,
	 4171949898,3886039621,1661344005,3424285243,992588372,
	 2500984144,2993248497,3590193895,1535327365,515645636,
	 131633450,3729760261,1613045101,3254194278,15889678,
	 1493590689,244148718,2991472662,1401629333,777349878,
	 2501401703,4285518317,3794656178,955526526,3442142820,
	 3970298374,736025417,2737370764,1271509744,440570731,
	 136141826,1596189518,923399175,257541519,3505774281,
	 2194358432,2518162991,1379893637,2667767062,3748146247,
	 1821712620,3923161384,1947811444,2392527197,4127419685,
	 1423694998,4156576871,1382885582,3420127279,3617499534,
	 2994377493,4038063986,1918458672,2983166794,4200449033,
	 353294540,1609232588,243926648,2332803291,507996832,
	 2392838793,4075145196,2060984340,4287475136,88232602,
	 2491531140,4159725633,2272075455,759298618,201384554,
	 838356250,1416268324,674476934,90795364,141672229,
	 3660399588,4196417251,3249270244,3774530247,59587265,
	 3683164208,19392575,1463123697,1882205379,293780489,
	 2553160622,2933904694,675638239,2851336944,1435238743,
	 2448730183,804436302,2119845972,322560608,4097732704,
	 2987802540,641492617,2575442710,4217822703,3271835300,
	 2836418300,3739921620,2138378768,2879771855,4294903423,
	 3121097946,2603440486,2560820391,1012930944,2313499967,
	 584489368,3431165766,897384869,2062537737,2847889234,
	 3742362450,2951174585,4204621084,1109373893,3668075775,
	 2750138839,3518055702,733072558,4169325400,788493625
	],
    {Refrand, Refarray}.


	    
	

    
    
