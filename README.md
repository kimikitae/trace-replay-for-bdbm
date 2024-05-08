## Usage

Before using Trace Replay for BDBM, preprocess your trace file into the required format:

timestamp     cpuid     sectornum   sectorsize   r/w flag(r:1, w:0)  
20037.038810533 8   648337288   64  1  
20037.038900485 24  959792368   16  1  


Once you have the preprocessed trace file:

1. Compile the `warm_up_trace.c` to generate the executable file using `gcc`. This step is necessary to fill the mapping table required for reading.

   ```sh
   gcc warm_up_trace.c -o warm_up_trace
   ```

2. Run the compiled program with the following command to generate the warm-up data:

   ```sh
   ./warm_up_trace [input file] [output file]
   Example:
   ./warm_up_trace YCSB-trace-16.dat warm_up_trace.dat
   ```
   
3. Install the necessary libraries for BDBM and libmemio. You can find the installation instructions for BDBM at [BDBM address link] and for libmemio at [libmemio address link].

4. If you have modified libmemio, navigate to its directory and clean the project before copying the generated library to the trace-replay directory and the user library location:

   ```sh
   sudo sh ./build.sh install && sudo cp ./project/libmemio.a ~/trace-replay/libmemio.a && sudo cp ./project/libmemio.a /usr/local/include/memio/libmemio.a
   ```

5. If you have modified the FTL, navigate to its directory and clean the project before copying the generated library to the trace-replay directory and the user library location:

    ```sh
   make clean && make && sudo cp libftl.a ~/trace-replay/libftl.a && sudo cp libftl.a /usr/local/include/ftl/libftl.a
   ```

6. After completing the preparations, execute the trace replay using the following command. Currently, only single-threaded execution is supported, and the replay ends when the trace file finishes, not based on time. Input the duration in seconds; if 100000 seconds are input, the replay will likely end when the file finishes.

    ```sh
   sudo make clean
   make
   sudo ./trace_replay 8 1 result.txt 100000 1 /dev/ram11 YCSB-trace-16.dat 0 0 0
   ```



#[Moved to GitHub!](https://github.com/yongseokoh/trace-replay)#

# trace-replay #

trace-replay is a tool to generate realistic block-level I/O traces with multiple threads to mimic virtualization like workloads. It mainly utilizes traces forming DiskSim format. It also offers some options such as the number of threads, I/O depth, block size, and synthetic workloads (e.g., sequential and random workloads) to accurately evaluate storage devices.

## Developers ##

* Yongseok Oh (SK telecom Storage Tech. Lab, yongseok.oh@sk.com)
* Eunjae Lee (UNIST, kckjn97@gmail.com)


## Installation Guide ##

trace-reply requires aio and pthread libraries. 

**Build** 

```sh
$ git clone https://bitbucket.org/yongseokoh/trace-replay.git
$ make
$ ./trace_replay 
```


** Example of Replaying a Single Trace **

```sh
$ ./trace_replay [qdepth] [per_thread] [output] [runtime in seconds] [trace_repeat] [devicefile] [tracefile1] [timescale1] [0] [0]
$ ./trace_replay 32 8 result.txt 60 1 /dev/sdb1 trace.dat 0 0 0
```


** Example of Replaying Multiple Traces **

```sh
$ ./trace_replay [qdepth] [per_thread] [output] [runtime in seconds] [trace_repeat] [devicefile] [tracefile1] [timescale1] [0] [0]
$ ./trace_replay 32 8 result.txt 60 1 /dev/sdb1 trace1.dat 0 0 0 trace2.dat 0 0 0 trace3.dat 0 0 0 trace4.dat 0 0 0
```


** Example of Generating Synthetic Workloads ** 
```sh
$ ./trace_replay [qdepth] [per_thread] [output] [runtime in seconds] [trace_repeat] [synth_type] [wss] [utilization] [iosize]
 synth_type: rand_read, rand_write, rand_mixed, seq_read, seq_write, seq_mixed
 wss (in MB unit)
 utilization (in pecent unit)
 iosize (in KB unit)

$ ./trace_replay 32 8 result.txt 60 1 /dev/sdb1 rand_write 128 100 4
```
## Transformation to DiskSim traces##

** To Do **

## Refences ##

* Sungyong Ahn, "Improving I/O Resource Sharing of Linux Cgroup for NVMe SSDs on Multi-core Systems," USENIX HotStorage 2016
* Yongsseok Oh, "Enabling Cost-Effective Flash based Caching with an Array of of Commodity SSDs," ACM/USENIX MIDDLEWARE 2015
* Eunjae Lee, "SSD caching to overcome small write problem of disk-based RAID in enterprise environments" ACM SAC 2015
* Jaeho Kim, "Towards SLO Complying SSDs through OPS Isolation" USENIX FAST 2015
