import UIKit

// Deadlock with two queues
func deadlockTest() {

    let queue1 = DispatchQueue(label: "com.gcd.serialQueue1")
    let queue2 = DispatchQueue(label: "com.gcd.serialQueue2")

    queue1.async {
        print(1)
        queue2.sync {
            print(2)
            queue1.sync {
                print("Deadlock here")
            }
        }
        print("And here")
    }
}

//deadlockTest()

// Cancellation of DispatchWorkItem

func testCancelation() {

    let queue3 = DispatchQueue.global(qos: .background)
    var item: DispatchWorkItem!

    item = DispatchWorkItem {
        while true {
            if item.isCancelled {
                break
            }
            print("0")
        }
    }

    queue3.async(execute: item)
    queue3.asyncAfter(deadline: .now() + 2) {
        item.cancel()
    }

}

testCancelation()
