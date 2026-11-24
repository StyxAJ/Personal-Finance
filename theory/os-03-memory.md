# OS 03 — Memory: address spaces and paging

## TL;DR
- **Address space** = the program's private view of memory: code, heap and stack, starting at address 0. Every process gets its own.
- Every address a program sees (any pointer, Python's `id()`) is a **virtual address**. It is not where the data really sits in RAM.
- **Who translates:** the **hardware (MMU)** turns every virtual address into a physical one, on every memory access. The **OS** sets up the rules it follows (the page tables) and steps in when something goes wrong.
- **Page** = a fixed-size chunk of the virtual address space (usually 4 KB). RAM is cut into chunks of the same size, called **frames**.
- **Page table** = one per process. It maps virtual page number (VPN) → physical frame number (PFN), plus some bits: valid, protection, present, dirty, referenced.
- Translation: split the address into **VPN + offset**, look up the VPN, swap in the PFN, and keep the offset as it is.

Sources: [OSTEP ch 13: The Abstraction: Address Spaces](https://pages.cs.wisc.edu/~remzi/OSTEP/vm-intro.pdf) · [OSTEP ch 18: Paging: Introduction](https://pages.cs.wisc.edu/~remzi/OSTEP/vm-paging.pdf) · [OSTEP book page](https://pages.cs.wisc.edu/~remzi/OSTEP/)

## What is it?

### Address space
- The **address space** is the memory as the running program sees it. It contains everything the program needs:
  - **code**: the instructions, at the top (low addresses).
  - **heap**: memory asked for at runtime (`malloc` in C, every object in Python). It grows down.
  - **stack**: local variables, function arguments and return addresses. It grows up, towards the heap.
- To the program it looks like one big private block starting at 0. That's an **illusion** the OS creates: in reality the data is spread around physical RAM, mixed in with other processes' data.
- OSTEP's line: **every address you can see as a programmer is a virtual address.** If you print a pointer, you get a virtual address.
- The OS has 3 goals for virtual memory:
  - **Transparency**: the program can't tell it's happening, and acts as if it has its own memory.
  - **Efficiency**: it costs little time and space (which needs hardware help).
  - **Protection / isolation**: a process can't read or write anyone else's memory, or the OS's.

### Virtual vs physical address, and who translates
- **Virtual address** = what the program uses. **Physical address** = the real location in RAM.
- **The hardware translates**, using a part of the CPU called the **MMU** (memory management unit). It happens on *every* load, store and instruction fetch, so it has to be done in hardware to be fast.
- **The OS manages it**: it decides which physical memory each process gets, builds the page tables, and tells the CPU where the current process's page table is (a register: the page-table base register). On a context switch, the OS points that register at the next process's table.
- If a translation fails (an invalid page, or a write to a read-only page), the hardware **traps to the OS**, which usually kills the process. In C that shows up as a segmentation fault.

### Pages and page tables
- **Paging** cuts the virtual address space into **fixed-size pages**, and physical memory into **frames** of the same size. Any page can go in any free frame.
- A virtual address splits into two parts:
  - **VPN** (virtual page number): the high bits, saying *which page*.
  - **offset**: the low bits, saying *which byte inside that page*.
- The **page table** is a per-process lookup table, indexed by VPN. Each entry (a **PTE**) stores:
  - **PFN**: the physical frame this page lives in. This is the main job.
  - **valid bit**: is this page in use at all? The unused gap between heap and stack is invalid, and touching it traps.
  - **protection bits**: may this page be read, written, or executed?
  - **present bit**: is the page in RAM, or swapped out to disk?
  - **dirty bit**: has the page been written to since it was loaded?
  - **reference (accessed) bit**: has it been used recently? This helps the OS choose what to swap out.
- Translation only replaces the VPN with the PFN. **The offset stays the same**, because a page and its frame have the same size and layout.

## Why does it exist?
- **Many programs at once.** Several processes share one RAM, and each needs memory that looks like its own.
- **Protection.** Without separate address spaces, a bug in one program (or a malicious program) could overwrite another program, or the OS. With them, a bad address can only reach your own memory, or trap.
- **Ease of programming.** Every program can be written as if it owns the memory from address 0 up. It doesn't need to know where it will be loaded or who else is running.
- **Why pages, instead of one block per process?** If each process got one contiguous block of RAM, memory would end up full of small unusable gaps between blocks (**external fragmentation**). Fixed-size pages fit into any free frame, so there are no awkward gaps. The space between heap and stack doesn't need frames at all: those pages are simply marked invalid.
- **The costs of paging:**
  - **Speed.** A naive lookup needs an extra memory access (to read the PTE) for every real memory access. The fix is a cache of recent translations called the **TLB**, which is the next chapter.
  - **Size.** A 32-bit address space with 4 KB pages has 2²⁰ ≈ 1 million pages. At 4 bytes per PTE, that's **4 MB of page table per process**.

## An example

### Q1: Address space, and why every process gets its own
When I work on the finance app, three processes run side by side: `uvicorn` (my FastAPI app), `postgres`, and `psql`. Each one has its own address space with its own code, heap and stack, and each one thinks its memory starts at 0.

- If my FastAPI code had a memory bug that wrote to a random address, it would land **in uvicorn's own address space**. It can't reach Postgres's memory and damage the database, because Postgres's memory isn't in uvicorn's address space at all. No virtual address in uvicorn translates to Postgres's frames.
- Python shows this directly: `hex(id(x))` prints the address of an object, such as `0x1f3a2b4c8c0`. That's a **virtual** address in that Python process's address space. Another Python process can use exactly the same number for its own, completely different, object.

### Q2: Virtual vs physical, and who translates
In `psycopg`, my program reads `row[0]`, the `Decimal('15000.00')` from the database. The Python object sits at some virtual address `V`.

1. The CPU executes the load from `V`.
2. The **MMU (hardware)** splits `V` into VPN and offset, and looks up the VPN in uvicorn's page table, which the **OS** built when the process started.
3. The PTE says the page is valid, readable, and in frame `F`. The MMU builds the physical address from `F` and the same offset, and reads RAM there.
4. If the PTE said "invalid", the MMU would **trap to the OS** instead, and the OS would kill the process.

The OS isn't involved in steps 1–3. It set up the table beforehand, and only steps in at step 4.

### Q3: A page, and what the page table stores (OSTEP's tiny example)
A **64-byte** address space with **16-byte pages** has 64 / 16 = **4 pages**, so the addresses are 6 bits long:
- 4 pages → 2 bits for the **VPN**.
- 16 bytes per page → 4 bits for the **offset**.

The process's page table:

| VPN | PFN | valid | protection |
|---|---|---|---|
| 0 | 3 | 1 | r-x (code) |
| 1 | 7 | 1 | rw- (heap) |
| 2 | — | 0 | — (unused gap) |
| 3 | 5 | 1 | rw- (stack) |

Translating virtual address **21**:

```
21 in binary     = 01 0101
                   ^^ ^^^^
                  VPN offset
VPN = 01 = 1  →  page table row 1  →  PFN = 7 (111), valid, rw-
physical         = 111 0101  =  117
```

So virtual address 21 is physical address 117. The offset `0101` (byte 5 of the page) didn't change, only the page number did.

A load from VPN 2 (virtual addresses 32–47) finds `valid = 0`, so the hardware traps and the OS kills the process: the segfault case.

## An interview question
**Q:** What is an address space, and why does every process get its own?

**A:** It's the OS's abstraction of memory for one running program: its code, heap and stack, laid out as if it had a private memory starting at 0. Every process gets its own so that processes are isolated: a bug in one can't overwrite another process or the OS. It also lets every program be written as if it owned the whole memory, without caring where in RAM it actually ends up.

**Q:** What's the difference between a virtual and a physical address, and who translates between them?

**A:** A virtual address is the one the program uses, and every pointer a program sees is virtual. A physical address is the real location in RAM. The hardware, specifically the MMU, translates on every memory access, using page tables that the OS sets up and switches between processes. The OS only gets involved when translation fails, for example on an invalid page, where the hardware traps to it.

**Q:** What is a page, and what does a page table store?

**A:** A page is a fixed-size chunk of the virtual address space, typically 4 KB, and physical memory is cut into frames of the same size. Each process has a page table that maps virtual page numbers to physical frame numbers. Each entry also holds a valid bit, protection bits (read/write/execute), a present bit (in RAM or swapped out), a dirty bit, and a reference bit. To translate an address, you split it into VPN and offset, replace the VPN with the PFN from the table, and keep the offset.

**Q:** Why paging, and what does it cost?

**A:** Fixed-size pages fit into any free frame, so there's no external fragmentation, and unused parts of the address space don't take up any RAM. The costs are speed and space. Speed: every memory access needs an extra lookup in the page table, which is why CPUs have a TLB to cache translations. Space: a 32-bit address space with 4 KB pages has about a million entries, which is around 4 MB of page table per process.
