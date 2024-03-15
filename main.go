package main

import (
	"flag"
	"fmt"
	"runtime"
	"sync"
)

func main() {
	// 定义命令行参数
	cpuCount := flag.Int("c", 1, "cpu count for 100% usage")
	flag.Parse()
	// 如果用户没有提供 -c 或 --count 参数，则打印提示信息并退出
	if *cpuCount <= 0 {
		fmt.Println("please set cpu count for 100% usage")
		return
	}

	fmt.Println("using cpu count ", *cpuCount)
	// 设置 Go 程序使用指定数量的 CPU
	runtime.GOMAXPROCS(*cpuCount)

	// 创建一个等待组，用于等待所有计算完成
	var wg sync.WaitGroup

	// 定义要进行计算的任务数量
	numTasks := 100

	// 增加等待组的计数器
	wg.Add(numTasks)

	// 启动多个 goroutine 进行计算
	for i := 0; i < numTasks; i++ {
		go func() {
			// 进行一些需要大量计算的操作
			calculate()

			// 减少等待组的计数器
			wg.Done()
		}()
	}

	// 等待所有计算完成
	wg.Wait()
	fmt.Println("complete")
}

func calculate() {
	// 进行一些需要大量计算的操作
	// 这里可以根据实际需求进行适当的计算
	// 例如循环、递归等
	i := 0
	for {
		i = i >> 2
	}
}
