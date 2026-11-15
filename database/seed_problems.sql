PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;
-- =============================================================================
-- CodeBox: Seed Data (Phase 3 - 30 LeetCode DSA Problems & Lookups)
-- =============================================================================

-- 1. Difficulties Lookup
INSERT OR IGNORE INTO difficulties (difficulty_id, label, points) VALUES
(1, 'Easy', 10),
(2, 'Medium', 20),
(3, 'Hard', 30);

-- 2. Categories Lookup
INSERT OR IGNORE INTO categories (category_id, name) VALUES
(1, 'Arrays'),
(2, 'Strings'),
(3, 'Hashing'),
(4, 'Two Pointers'),
(5, 'Binary Search'),
(6, 'Stack'),
(7, 'Linked List'),
(8, 'Dynamic Programming'),
(9, 'Trees'),
(10, 'Math');

-- 3. Languages Lookup
INSERT OR IGNORE INTO languages (language_id, name, display_name, docker_image) VALUES
(1, 'cpp', 'C++17', 'gcc:latest'),
(2, 'python', 'Python 3', 'python:3'),
(3, 'java', 'Java 17', 'openjdk:17'),
(4, 'c', 'C (GCC)', 'gcc:latest');

-- 5. 30 Complete LeetCode Problems & Test Cases
INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  1, 'Two Sum', 'two-sum', 'Given an array of integers <code>nums</code> and an integer <code>target</code>, return indices of the two numbers such that they add up to <code>target</code>.<br/><br/>You may assume that each input would have <b>exactly one solution</b>, and you may not use the same element twice. Return the answer sorted in ascending order.', '2 <= nums.length <= 10^4<br/>-10^9 <= nums[i] <= 10^9<br/>-10^9 <= target <= 10^9',
  1, 1,
  '#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];
    int target;
    cin >> target;

    unordered_map<int, int> seen;
    for (int i = 0; i < n; i++) {
        int complement = target - nums[i];
        if (seen.count(complement)) {
            cout << seen[complement] << " " << i << endl;
            return 0;
        }
        seen[nums[i]] = i;
    }
    return 0;
}
',
  'import sys

def main():
    input_data = sys.stdin.read().split()
    if not input_data:
        return
    n = int(input_data[0])
    nums = [int(x) for x in input_data[1:1+n]]
    target = int(input_data[1+n])
    
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            print(f"{seen[complement]} {i}")
            return
        seen[num] = i

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] nums = new int[n];
        for (int i = 0; i < n; i++) nums[i] = sc.nextInt();
        int target = sc.nextInt();

        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < n; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                System.out.println(map.get(complement) + " " + i);
                return;
            }
            map.put(nums[i], i);
        }
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int target;
    scanf("%d", &target);

    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (nums[i] + nums[j] == target) {
                printf("%d %d\n", i, j);
                free(nums);
                return 0;
            }
        }
    }
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (1, '4
2 7 11 15
9', '0 1', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (1, '3
3 2 4
6', '1 2', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (1, '2
3 3
6', '0 1', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  2, 'Palindrome Number', 'palindrome-number', 'Given an integer <code>x</code>, return <code>true</code> if <code>x</code> is a palindrome, and <code>false</code> otherwise.<br/><br/>An integer is a palindrome when it reads the same forward and backward (e.g., 121 is palindrome, while 123 is not).', '-2^31 <= x <= 2^31 - 1',
  1, 10,
  '#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

int main() {
    long long x;
    if (!(cin >> x)) return 0;
    if (x < 0) {
        cout << "false" << endl;
        return 0;
    }
    string s = to_string(x);
    string r = s;
    reverse(r.begin(), r.end());
    cout << (s == r ? "true" : "false") << endl;
    return 0;
}
',
  'import sys

def main():
    s = sys.stdin.read().strip()
    if not s:
        return
    if s[0] == ''-'':
        print("false")
    else:
        print("true" if s == s[::-1] else "false")

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;
        String s = sc.next();
        if (s.startsWith("-")) {
            System.out.println("false");
            return;
        }
        String rev = new StringBuilder(s).reverse().toString();
        System.out.println(s.equals(rev) ? "true" : "false");
    }
}
',
  '#include <stdio.h>
#include <stdbool.h>

int main() {
    long long x;
    if (scanf("%lld", &x) != 1) return 0;
    if (x < 0) {
        printf("false\n");
        return 0;
    }
    long long orig = x, rev = 0;
    while (x > 0) {
        rev = rev * 10 + (x % 10);
        x /= 10;
    }
    if (orig == rev) printf("true\n");
    else printf("false\n");
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (2, '121', 'true', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (2, '-121', 'false', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (2, '10', 'false', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  3, 'Valid Parentheses', 'valid-parentheses', 'Given a string <code>s</code> containing just the characters <code>''(''</code>, <code>'')''</code>, <code>''{''</code>, <code>''}''</code>, <code>''[''</code> and <code>'']''</code>, determine if the input string is valid.<br/><br/>Open brackets must be closed by the same type of brackets, and in the correct order.', '1 <= s.length <= 10^4<br/>s consists of parentheses only ''()[]{}''.',
  1, 6,
  '#include <iostream>
#include <string>
#include <stack>
using namespace std;

int main() {
    string s;
    if (!(cin >> s)) return 0;
    stack<char> st;
    bool ok = true;
    for (char c : s) {
        if (c == ''('' || c == ''{'' || c == ''['') st.push(c);
        else {
            if (st.empty()) { ok = false; break; }
            char top = st.top(); st.pop();
            if ((c == '')'' && top != ''('') || (c == ''}'' && top != ''{'') || (c == '']'' && top != ''['')) {
                ok = false; break;
            }
        }
    }
    if (!st.empty()) ok = false;
    cout << (ok ? "true" : "false") << endl;
    return 0;
}
',
  'import sys

def main():
    s = sys.stdin.read().strip()
    stack = []
    pairs = {'')'': ''('', ''}'': ''{'', '']'': ''[''}
    for c in s:
        if c in ''({['':
            stack.append(c)
        elif c in pairs:
            if not stack or stack[-1] != pairs[c]:
                print("false")
                return
            stack.pop()
    print("true" if not stack else "false")

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;
        String s = sc.next();
        Deque<Character> st = new ArrayDeque<>();
        boolean ok = true;
        for (char c : s.toCharArray()) {
            if (c == ''('' || c == ''{'' || c == ''['') st.push(c);
            else {
                if (st.isEmpty()) { ok = false; break; }
                char top = st.pop();
                if ((c == '')'' && top != ''('') || (c == ''}'' && top != ''{'') || (c == '']'' && top != ''['')) {
                    ok = false; break;
                }
            }
        }
        if (!st.isEmpty()) ok = false;
        System.out.println(ok ? "true" : "false");
    }
}
',
  '#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int main() {
    char s[10005];
    if (scanf("%s", s) != 1) return 0;
    char stack[10005];
    int top = -1;
    bool ok = true;
    for (int i = 0; s[i] != ''\0''; i++) {
        char c = s[i];
        if (c == ''('' || c == ''{'' || c == ''['') {
            stack[++top] = c;
        } else {
            if (top < 0) { ok = false; break; }
            char t = stack[top--];
            if ((c == '')'' && t != ''('') || (c == ''}'' && t != ''{'') || (c == '']'' && t != ''['')) {
                ok = false; break;
            }
        }
    }
    if (top != -1) ok = false;
    printf("%s\n", ok ? "true" : "false");
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (3, '()[]{}', 'true', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (3, '(]', 'false', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (3, '([{}])', 'true', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  4, 'Merge Two Sorted Lists', 'merge-two-sorted-lists', 'You are given the heads of two sorted linked lists <code>list1</code> and <code>list2</code>. Merge the two lists into one sorted list and print the elements space-separated.', '0 <= list1.length, list2.length <= 50<br/>-100 <= Node.val <= 100',
  1, 7,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n1, n2;
    if (!(cin >> n1)) return 0;
    vector<int> a(n1);
    for (int i = 0; i < n1; i++) cin >> a[i];
    cin >> n2;
    vector<int> b(n2);
    for (int i = 0; i < n2; i++) cin >> b[i];

    vector<int> res;
    int i = 0, j = 0;
    while (i < n1 && j < n2) {
        if (a[i] <= b[j]) res.push_back(a[i++]);
        else res.push_back(b[j++]);
    }
    while (i < n1) res.push_back(a[i++]);
    while (j < n2) res.push_back(b[j++]);

    for (size_t k = 0; k < res.size(); k++) {
        cout << res[k] << (k + 1 == res.size() ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys

def main():
    data = sys.stdin.read().split()
    if not data:
        return
    idx = 0
    n1 = int(data[idx]); idx += 1
    a = [int(x) for x in data[idx:idx+n1]]; idx += n1
    n2 = int(data[idx]); idx += 1
    b = [int(x) for x in data[idx:idx+n2]]; idx += n2

    res = sorted(a + b)
    print(" ".join(map(str, res)))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n1 = sc.nextInt();
        List<Integer> list = new ArrayList<>();
        for (int i = 0; i < n1; i++) list.add(sc.nextInt());
        int n2 = sc.nextInt();
        for (int i = 0; i < n2; i++) list.add(sc.nextInt());
        Collections.sort(list);
        for (int i = 0; i < list.size(); i++) {
            System.out.print(list.get(i) + (i + 1 == list.size() ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n1, n2;
    if (scanf("%d", &n1) != 1) return 0;
    int* a = (int*)malloc((n1 + 1) * sizeof(int));
    for (int i = 0; i < n1; i++) scanf("%d", &a[i]);
    scanf("%d", &n2);
    int* b = (int*)malloc((n2 + 1) * sizeof(int));
    for (int i = 0; i < n2; i++) scanf("%d", &b[i]);

    int* res = (int*)malloc((n1 + n2 + 1) * sizeof(int));
    int i = 0, j = 0, k = 0;
    while (i < n1 && j < n2) {
        if (a[i] <= b[j]) res[k++] = a[i++];
        else res[k++] = b[j++];
    }
    while (i < n1) res[k++] = a[i++];
    while (j < n2) res[k++] = b[j++];

    for (int idx = 0; idx < k; idx++) {
        printf("%d%s", res[idx], (idx + 1 == k ? "" : " "));
    }
    printf("\n");
    free(a); free(b); free(res);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (4, '3
1 2 4
3
1 3 4', '1 1 2 3 4 4', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (4, '0
0', '', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (4, '1
2
2
1 3', '1 2 3', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  5, 'Best Time to Buy and Sell Stock', 'best-time-to-buy-and-sell-stock', 'You are given an array <code>prices</code> where <code>prices[i]</code> is the price of a given stock on the <code>i-th</code> day. Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.', '1 <= prices.length <= 10^5<br/>0 <= prices[i] <= 10^4',
  1, 1,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> p(n);
    for (int i = 0; i < n; i++) cin >> p[i];
    int minPrice = 1e9, maxProfit = 0;
    for (int price : p) {
        minPrice = min(minPrice, price);
        maxProfit = max(maxProfit, price - minPrice);
    }
    cout << maxProfit << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    prices = nums[1:1+n]
    min_price = float(''inf'')
    max_profit = 0
    for price in prices:
        if price < min_price:
            min_price = price
        elif price - min_price > max_profit:
            max_profit = price - min_price
    print(max_profit)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int minPrice = Integer.MAX_VALUE, maxProfit = 0;
        for (int i = 0; i < n; i++) {
            int price = sc.nextInt();
            if (price < minPrice) minPrice = price;
            else if (price - minPrice > maxProfit) maxProfit = price - minPrice;
        }
        System.out.println(maxProfit);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int minPrice = 1e9, maxProfit = 0;
    for (int i = 0; i < n; i++) {
        int price;
        scanf("%d", &price);
        if (price < minPrice) minPrice = price;
        int profit = price - minPrice;
        if (profit > maxProfit) maxProfit = profit;
    }
    printf("%d\n", maxProfit);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (5, '6
7 1 5 3 6 4', '5', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (5, '5
7 6 4 3 1', '0', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (5, '2
1 9', '8', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  6, 'Valid Anagram', 'valid-anagram', 'Given two strings <code>s</code> and <code>t</code>, return <code>true</code> if <code>t</code> is an anagram of <code>s</code>, and <code>false</code> otherwise.', '1 <= s.length, t.length <= 5 * 10^4<br/>s and t consist of lowercase English letters.',
  1, 2,
  '#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

int main() {
    string s, t;
    if (!(cin >> s >> t)) return 0;
    sort(s.begin(), s.end());
    sort(t.begin(), t.end());
    cout << (s == t ? "true" : "false") << endl;
    return 0;
}
',
  'import sys

def main():
    parts = sys.stdin.read().split()
    if len(parts) < 2:
        return
    s, t = parts[0], parts[1]
    print("true" if sorted(s) == sorted(t) else "false")

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;
        String s = sc.next();
        String t = sc.next();
        char[] a = s.toCharArray();
        char[] b = t.toCharArray();
        Arrays.sort(a);
        Arrays.sort(b);
        System.out.println(Arrays.equals(a, b) ? "true" : "false");
    }
}
',
  '#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int main() {
    char s[10005], t[10005];
    if (scanf("%s %s", s, t) != 2) return 0;
    if (strlen(s) != strlen(t)) {
        printf("false\n");
        return 0;
    }
    int count[26] = {0};
    for (int i = 0; s[i] != ''\0''; i++) {
        count[s[i] - ''a'']++;
        count[t[i] - ''a'']--;
    }
    bool ok = true;
    for (int i = 0; i < 26; i++) {
        if (count[i] != 0) { ok = false; break; }
    }
    printf("%s\n", ok ? "true" : "false");
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (6, 'anagram nagaram', 'true', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (6, 'rat car', 'false', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (6, 'listen silent', 'true', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  7, 'Binary Search', 'binary-search', 'Given an array of integers <code>nums</code> which is sorted in ascending order, and an integer <code>target</code>, write a function to search <code>target</code> in <code>nums</code>. If <code>target</code> exists, then return its index. Otherwise, return <code>-1</code>.', '1 <= nums.length <= 10^4<br/>All integers in nums are unique.',
  1, 5,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];
    int target;
    cin >> target;

    int left = 0, right = n - 1;
    int ans = -1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] == target) { ans = mid; break; }
        else if (nums[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    cout << ans << endl;
    return 0;
}
',
  'import sys

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    nums = data[1:1+n]
    target = data[1+n]
    
    left, right = 0, n - 1
    ans = -1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            ans = mid
            break
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    print(ans)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] nums = new int[n];
        for (int i = 0; i < n; i++) nums[i] = sc.nextInt();
        int target = sc.nextInt();

        int left = 0, right = n - 1, ans = -1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (nums[mid] == target) { ans = mid; break; }
            else if (nums[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        System.out.println(ans);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int target;
    scanf("%d", &target);

    int l = 0, r = n - 1, ans = -1;
    while (l <= r) {
        int mid = l + (r - l) / 2;
        if (nums[mid] == target) { ans = mid; break; }
        else if (nums[mid] < target) l = mid + 1;
        else r = mid - 1;
    }
    printf("%d\n", ans);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (7, '6
-1 0 3 5 9 12
9', '4', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (7, '6
-1 0 3 5 9 12
2', '-1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (7, '1
5
5', '0', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  8, 'Maximum Subarray', 'maximum-subarray', 'Given an integer array <code>nums</code>, find the subarray with the largest sum, and return its sum (Kadane''s Algorithm).', '1 <= nums.length <= 10^5<br/>-10^4 <= nums[i] <= 10^4',
  2, 8,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];

    long long maxSoFar = nums[0], currMax = nums[0];
    for (int i = 1; i < n; i++) {
        currMax = max((long long)nums[i], currMax + nums[i]);
        maxSoFar = max(maxSoFar, currMax);
    }
    cout << maxSoFar << endl;
    return 0;
}
',
  'import sys

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    nums = data[1:1+n]
    max_so_far = curr = nums[0]
    for x in nums[1:]:
        curr = max(x, curr + x)
        max_so_far = max(max_so_far, curr)
    print(max_so_far)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        long maxSoFar = sc.nextInt();
        long curr = maxSoFar;
        for (int i = 1; i < n; i++) {
            long x = sc.nextInt();
            curr = Math.max(x, curr + x);
            maxSoFar = Math.max(maxSoFar, curr);
        }
        System.out.println(maxSoFar);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    long long maxSoFar, currMax;
    int first;
    scanf("%d", &first);
    maxSoFar = currMax = first;
    for (int i = 1; i < n; i++) {
        int val;
        scanf("%d", &val);
        currMax = (val > currMax + val) ? val : (currMax + val);
        if (currMax > maxSoFar) maxSoFar = currMax;
    }
    printf("%lld\n", maxSoFar);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (8, '9
-2 1 -3 4 -1 2 1 -5 4', '6', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (8, '1
1', '1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (8, '5
5 4 -1 7 8', '23', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  9, 'Climbing Stairs', 'climbing-stairs', 'You are climbing a staircase. It takes <code>n</code> steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?', '1 <= n <= 45',
  1, 8,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    if (n <= 2) { cout << n << endl; return 0; }
    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }
    cout << b << endl;
    return 0;
}
',
  'import sys

def main():
    s = sys.stdin.read().strip()
    if not s:
        return
    n = int(s)
    if n <= 2:
        print(n)
        return
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    print(b)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        if (n <= 2) { System.out.println(n); return; }
        int a = 1, b = 2;
        for (int i = 3; i <= n; i++) {
            int c = a + b;
            a = b;
            b = c;
        }
        System.out.println(b);
    }
}
',
  '#include <stdio.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    if (n <= 2) { printf("%d\n", n); return 0; }
    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }
    printf("%d\n", b);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (9, '2', '2', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (9, '3', '3', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (9, '5', '8', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  10, 'Coin Change', 'coin-change', 'You are given an integer array <code>coins</code> representing coins of different denominations and an integer <code>amount</code>. Return the fewest number of coins that you need to make up that amount. If that amount cannot be made up by any combination, return <code>-1</code>.', '1 <= coins.length <= 12<br/>1 <= coins[i] <= 2^31 - 1<br/>0 <= amount <= 10^4',
  2, 8,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> coins(n);
    for (int i = 0; i < n; i++) cin >> coins[i];
    int amount;
    cin >> amount;

    vector<int> dp(amount + 1, amount + 1);
    dp[0] = 0;
    for (int i = 1; i <= amount; i++) {
        for (int c : coins) {
            if (i >= c) dp[i] = min(dp[i], dp[i - c] + 1);
        }
    }
    cout << (dp[amount] > amount ? -1 : dp[amount]) << endl;
    return 0;
}
',
  'import sys

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    coins = data[1:1+n]
    amount = data[1+n]

    dp = [float(''inf'')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for c in coins:
            if i >= c:
                dp[i] = min(dp[i], dp[i - c] + 1)
    print(-1 if dp[amount] == float(''inf'') else dp[amount])

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] coins = new int[n];
        for (int i = 0; i < n; i++) coins[i] = sc.nextInt();
        int amount = sc.nextInt();

        int[] dp = new int[amount + 1];
        Arrays.fill(dp, amount + 1);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) {
            for (int c : coins) {
                if (i >= c) dp[i] = Math.min(dp[i], dp[i - c] + 1);
            }
        }
        System.out.println(dp[amount] > amount ? -1 : dp[amount]);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* coins = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &coins[i]);
    int amount;
    scanf("%d", &amount);

    int* dp = (int*)malloc((amount + 1) * sizeof(int));
    dp[0] = 0;
    for (int i = 1; i <= amount; i++) dp[i] = amount + 2;

    for (int i = 1; i <= amount; i++) {
        for (int j = 0; j < n; j++) {
            if (i >= coins[j]) {
                int cand = dp[i - coins[j]] + 1;
                if (cand < dp[i]) dp[i] = cand;
            }
        }
    }
    printf("%d\n", (dp[amount] > amount ? -1 : dp[amount]));
    free(coins); free(dp);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (10, '3
1 2 5
11', '3', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (10, '1
2
3', '-1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (10, '1
1
0', '0', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  11, 'Longest Substring Without Repeating Characters', 'longest-substring-without-repeating-characters', 'Given a string <code>s</code>, find the length of the longest substring without repeating characters.', '0 <= s.length <= 5 * 10^4',
  2, 2,
  '#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    string s;
    if (!getline(cin, s)) return 0;
    vector<int> last(256, -1);
    int maxLen = 0, start = 0;
    for (int i = 0; i < (int)s.size(); i++) {
        unsigned char c = s[i];
        if (last[c] >= start) start = last[c] + 1;
        last[c] = i;
        maxLen = max(maxLen, i - start + 1);
    }
    cout << maxLen << endl;
    return 0;
}
',
  'import sys

def main():
    line = sys.stdin.read().rstrip(''\r\n'')
    used = {}
    max_len = start = 0
    for i, c in enumerate(line):
        if c in used and used[c] >= start:
            start = used[c] + 1
        used[c] = i
        max_len = max(max_len, i - start + 1)
    print(max_len)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextLine()) return;
        String s = sc.nextLine();
        int[] last = new int[256];
        Arrays.fill(last, -1);
        int maxLen = 0, start = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (last[c] >= start) start = last[c] + 1;
            last[c] = i;
            maxLen = Math.max(maxLen, i - start + 1);
        }
        System.out.println(maxLen);
    }
}
',
  '#include <stdio.h>
#include <string.h>

int main() {
    char s[100005];
    if (!fgets(s, sizeof(s), stdin)) return 0;
    int len = strlen(s);
    if (len > 0 && (s[len - 1] == ''\n'' || s[len - 1] == ''\r'')) {
        s[--len] = ''\0'';
        if (len > 0 && s[len - 1] == ''\r'') s[--len] = ''\0'';
    }
    int last[256];
    for (int i = 0; i < 256; i++) last[i] = -1;
    int maxLen = 0, start = 0;
    for (int i = 0; i < len; i++) {
        unsigned char c = (unsigned char)s[i];
        if (last[c] >= start) start = last[c] + 1;
        last[c] = i;
        int cur = i - start + 1;
        if (cur > maxLen) maxLen = cur;
    }
    printf("%d\n", maxLen);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (11, 'abcabcbb', '3', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (11, 'bbbbb', '1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (11, 'pwwkew', '3', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  12, '3Sum', '3sum', 'Given an integer array nums, return the number of unique triplets <code>[nums[i], nums[j], nums[k]]</code> such that <code>i != j</code>, <code>i != k</code>, and <code>j != k</code>, and <code>nums[i] + nums[j] + nums[k] == 0</code>.', '3 <= nums.length <= 3000<br/>-10^5 <= nums[i] <= 10^5',
  2, 4,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> a(n);
    for (int i = 0; i < n; i++) cin >> a[i];
    sort(a.begin(), a.end());
    int count = 0;
    for (int i = 0; i < n - 2; i++) {
        if (i > 0 && a[i] == a[i - 1]) continue;
        int l = i + 1, r = n - 1;
        while (l < r) {
            int sum = a[i] + a[l] + a[r];
            if (sum == 0) {
                count++;
                while (l < r && a[l] == a[l + 1]) l++;
                while (l < r && a[r] == a[r - 1]) r--;
                l++; r--;
            } else if (sum < 0) l++;
            else r--;
        }
    }
    cout << count << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = sorted(nums[1:1+n])
    count = 0
    for i in range(n - 2):
        if i > 0 and a[i] == a[i - 1]:
            continue
        l, r = i + 1, n - 1
        while l < r:
            s = a[i] + a[l] + a[r]
            if s == 0:
                count += 1
                while l < r and a[l] == a[l + 1]: l += 1
                while l < r and a[r] == a[r - 1]: r -= 1
                l += 1; r -= 1
            elif s < 0:
                l += 1
            else:
                r -= 1
    print(count)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = sc.nextInt();
        Arrays.sort(a);
        int count = 0;
        for (int i = 0; i < n - 2; i++) {
            if (i > 0 && a[i] == a[i - 1]) continue;
            int l = i + 1, r = n - 1;
            while (l < r) {
                int sum = a[i] + a[l] + a[r];
                if (sum == 0) {
                    count++;
                    while (l < r && a[l] == a[l + 1]) l++;
                    while (l < r && a[r] == a[r - 1]) r--;
                    l++; r--;
                } else if (sum < 0) l++;
                else r--;
            }
        }
        System.out.println(count);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int cmp(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* a = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);
    qsort(a, n, sizeof(int), cmp);

    int count = 0;
    for (int i = 0; i < n - 2; i++) {
        if (i > 0 && a[i] == a[i - 1]) continue;
        int l = i + 1, r = n - 1;
        while (l < r) {
            int sum = a[i] + a[l] + a[r];
            if (sum == 0) {
                count++;
                while (l < r && a[l] == a[l + 1]) l++;
                while (l < r && a[r] == a[r - 1]) r--;
                l++; r--;
            } else if (sum < 0) {
                l++;
            } else {
                r--;
            }
        }
    }
    printf("%d\n", count);
    free(a);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (12, '6
-1 0 1 2 -1 -4', '2', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (12, '3
0 1 1', '0', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (12, '3
0 0 0', '1', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  13, 'Product of Array Except Self', 'product-of-array-except-self', 'Given an integer array <code>nums</code>, return an array <code>answer</code> such that <code>answer[i]</code> is equal to the product of all the elements of <code>nums</code> except <code>nums[i]</code>. You must write an algorithm that runs in O(n) time without division.', '2 <= nums.length <= 10^5<br/>-30 <= nums[i] <= 30',
  2, 1,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> a(n), res(n, 1);
    for (int i = 0; i < n; i++) cin >> a[i];

    int prefix = 1;
    for (int i = 0; i < n; i++) {
        res[i] = prefix;
        prefix *= a[i];
    }
    int suffix = 1;
    for (int i = n - 1; i >= 0; i--) {
        res[i] *= suffix;
        suffix *= a[i];
    }

    for (int i = 0; i < n; i++) {
        cout << res[i] << (i + 1 == n ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    res = [1] * n
    prefix = 1
    for i in range(n):
        res[i] = prefix
        prefix *= a[i]
    suffix = 1
    for i in range(n - 1, -1, -1):
        res[i] *= suffix
        suffix *= a[i]
    print(" ".join(map(str, res)))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = sc.nextInt();
        int[] res = new int[n];
        int prefix = 1;
        for (int i = 0; i < n; i++) {
            res[i] = prefix;
            prefix *= a[i];
        }
        int suffix = 1;
        for (int i = n - 1; i >= 0; i--) {
            res[i] *= suffix;
            suffix *= a[i];
        }
        for (int i = 0; i < n; i++) {
            System.out.print(res[i] + (i + 1 == n ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* a = (int*)malloc(n * sizeof(int));
    int* res = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);

    int prefix = 1;
    for (int i = 0; i < n; i++) {
        res[i] = prefix;
        prefix *= a[i];
    }
    int suffix = 1;
    for (int i = n - 1; i >= 0; i--) {
        res[i] *= suffix;
        suffix *= a[i];
    }

    for (int i = 0; i < n; i++) {
        printf("%d%s", res[i], (i + 1 == n ? "" : " "));
    }
    printf("\n");
    free(a); free(res);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (13, '4
1 2 3 4', '24 12 8 6', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (13, '5
-1 1 0 -3 3', '0 0 9 0 0', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (13, '2
5 2', '2 5', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  14, 'Container With Most Water', 'container-with-most-water', 'You are given an integer array <code>height</code> of length <code>n</code>. There are <code>n</code> vertical lines drawn such that the two endpoints of the <code>i-th</code> line are <code>(i, 0)</code> and <code>(i, height[i])</code>. Find two lines that together with the x-axis form a container, such that the container contains the most water. Return the maximum amount of water a container can store.', 'n == height.length<br/>2 <= n <= 10^5<br/>0 <= height[i] <= 10^4',
  2, 4,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> h(n);
    for (int i = 0; i < n; i++) cin >> h[i];

    int l = 0, r = n - 1;
    long long maxArea = 0;
    while (l < r) {
        long long area = (long long)min(h[l], h[r]) * (r - l);
        maxArea = max(maxArea, area);
        if (h[l] < h[r]) l++;
        else r--;
    }
    cout << maxArea << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    h = nums[1:1+n]
    l, r = 0, n - 1
    max_area = 0
    while l < r:
        area = min(h[l], h[r]) * (r - l)
        if area > max_area:
            max_area = area
        if h[l] < h[r]:
            l += 1
        else:
            r -= 1
    print(max_area)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] h = new int[n];
        for (int i = 0; i < n; i++) h[i] = sc.nextInt();
        int l = 0, r = n - 1;
        long maxArea = 0;
        while (l < r) {
            long area = (long)Math.min(h[l], h[r]) * (r - l);
            if (area > maxArea) maxArea = area;
            if (h[l] < h[r]) l++;
            else r--;
        }
        System.out.println(maxArea);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* h = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &h[i]);

    int l = 0, r = n - 1;
    long long maxArea = 0;
    while (l < r) {
        int minH = (h[l] < h[r]) ? h[l] : h[r];
        long long area = (long long)minH * (r - l);
        if (area > maxArea) maxArea = area;
        if (h[l] < h[r]) l++;
        else r--;
    }
    printf("%lld\n", maxArea);
    free(h);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (14, '9
1 8 6 2 5 4 8 3 7', '49', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (14, '2
1 1', '1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (14, '4
4 3 2 14', '12', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  15, 'Group Anagrams', 'group-anagrams', 'Given an array of strings <code>strs</code>, group the anagrams together. Print the total number of distinct anagram groups formed.', '1 <= strs.length <= 10^4<br/>0 <= strs[i].length <= 100',
  2, 3,
  '#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    unordered_map<string, int> groups;
    for (int i = 0; i < n; i++) {
        string s;
        cin >> s;
        string key = s;
        sort(key.begin(), key.end());
        groups[key]++;
    }
    cout << groups.size() << endl;
    return 0;
}
',
  'import sys

def main():
    parts = sys.stdin.read().split()
    if not parts:
        return
    n = int(parts[0])
    words = parts[1:1+n]
    groups = {}
    for w in words:
        k = "".join(sorted(w))
        groups[k] = groups.get(k, 0) + 1
    print(len(groups))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        Map<String, Integer> map = new HashMap<>();
        for (int i = 0; i < n; i++) {
            String s = sc.next();
            char[] chars = s.toCharArray();
            Arrays.sort(chars);
            String k = new String(chars);
            map.put(k, map.getOrDefault(k, 0) + 1);
        }
        System.out.println(map.size());
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cmpChar(const void* a, const void* b) {
    return (*(char*)a - *(char*)b);
}

int cmpStr(const void* a, const void* b) {
    return strcmp(*(const char**)a, *(const char**)b);
}

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    char** keys = (char**)malloc(n * sizeof(char*));
    for (int i = 0; i < n; i++) {
        keys[i] = (char*)malloc(105 * sizeof(char));
        scanf("%s", keys[i]);
        qsort(keys[i], strlen(keys[i]), sizeof(char), cmpChar);
    }
    qsort(keys, n, sizeof(char*), cmpStr);

    int distinct = 0;
    for (int i = 0; i < n; i++) {
        if (i == 0 || strcmp(keys[i], keys[i - 1]) != 0) distinct++;
        free(keys[i]);
    }
    free(keys);
    printf("%d\n", distinct);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (15, '6
eat tea tan ate nat bat', '3', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (15, '1
a', '1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (15, '3
abc bca cba', '1', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  16, 'Trapping Rain Water', 'trapping-rain-water', 'Given <code>n</code> non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.', 'n == height.length<br/>1 <= n <= 2 * 10^4<br/>0 <= height[i] <= 10^5',
  3, 4,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> h(n);
    for (int i = 0; i < n; i++) cin >> h[i];

    int l = 0, r = n - 1;
    int maxL = 0, maxR = 0;
    long long water = 0;
    while (l < r) {
        if (h[l] <= h[r]) {
            if (h[l] >= maxL) maxL = h[l];
            else water += maxL - h[l];
            l++;
        } else {
            if (h[r] >= maxR) maxR = h[r];
            else water += maxR - h[r];
            r--;
        }
    }
    cout << water << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    h = nums[1:1+n]
    l, r = 0, n - 1
    max_l = max_r = water = 0
    while l < r:
        if h[l] <= h[r]:
            if h[l] >= max_l: max_l = h[l]
            else: water += max_l - h[l]
            l += 1
        else:
            if h[r] >= max_r: max_r = h[r]
            else: water += max_r - h[r]
            r -= 1
    print(water)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] h = new int[n];
        for (int i = 0; i < n; i++) h[i] = sc.nextInt();
        int l = 0, r = n - 1, maxL = 0, maxR = 0;
        long water = 0;
        while (l < r) {
            if (h[l] <= h[r]) {
                if (h[l] >= maxL) maxL = h[l];
                else water += maxL - h[l];
                l++;
            } else {
                if (h[r] >= maxR) maxR = h[r];
                else water += maxR - h[r];
                r--;
            }
        }
        System.out.println(water);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* h = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &h[i]);

    int l = 0, r = n - 1;
    int maxL = 0, maxR = 0;
    long long water = 0;
    while (l < r) {
        if (h[l] <= h[r]) {
            if (h[l] >= maxL) maxL = h[l];
            else water += maxL - h[l];
            l++;
        } else {
            if (h[r] >= maxR) maxR = h[r];
            else water += maxR - h[r];
            r--;
        }
    }
    printf("%lld\n", water);
    free(h);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (16, '12
0 1 0 2 1 0 1 3 2 1 2 1', '6', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (16, '6
4 2 0 3 2 5', '9', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (16, '3
2 0 2', '2', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  17, 'Edit Distance', 'edit-distance', 'Given two strings <code>word1</code> and <code>word2</code>, return the minimum number of operations required to convert <code>word1</code> to <code>word2</code> (insert, delete, or replace a character).', '0 <= word1.length, word2.length <= 500',
  3, 8,
  '#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    string w1, w2;
    if (!(cin >> w1)) w1 = "";
    if (!(cin >> w2)) w2 = "";
    int m = w1.size(), n = w2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (w1[i - 1] == w2[j - 1]) dp[i][j] = dp[i - 1][j - 1];
            else dp[i][j] = 1 + min({dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]});
        }
    }
    cout << dp[m][n] << endl;
    return 0;
}
',
  'import sys

def main():
    parts = sys.stdin.read().split()
    w1 = parts[0] if len(parts) > 0 else ""
    w2 = parts[1] if len(parts) > 1 else ""
    m, n = len(w1), len(w2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m + 1): dp[i][0] = i
    for j in range(n + 1): dp[0][j] = j
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if w1[i - 1] == w2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = 1 + min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])
    print(dp[m][n])

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String w1 = sc.hasNext() ? sc.next() : "";
        String w2 = sc.hasNext() ? sc.next() : "";
        int m = w1.length(), n = w2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 0; i <= m; i++) dp[i][0] = i;
        for (int j = 0; j <= n; j++) dp[0][j] = j;
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (w1.charAt(i - 1) == w2.charAt(j - 1)) dp[i][j] = dp[i - 1][j - 1];
                else dp[i][j] = 1 + Math.min(dp[i - 1][j - 1], Math.min(dp[i - 1][j], dp[i][j - 1]));
            }
        }
        System.out.println(dp[m][n]);
    }
}
',
  '#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int min3(int a, int b, int c) {
    int m = a < b ? a : b;
    return m < c ? m : c;
}

int main() {
    char w1[505] = "", w2[505] = "";
    if (scanf("%s", w1) != 1) w1[0] = ''\0'';
    if (scanf("%s", w2) != 1) w2[0] = ''\0'';
    int m = strlen(w1), n = strlen(w2);

    int** dp = (int**)malloc((m + 1) * sizeof(int*));
    for (int i = 0; i <= m; i++) dp[i] = (int*)malloc((n + 1) * sizeof(int));

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (w1[i - 1] == w2[j - 1]) dp[i][j] = dp[i - 1][j - 1];
            else dp[i][j] = 1 + min3(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]);
        }
    }
    printf("%d\n", dp[m][n]);
    for (int i = 0; i <= m; i++) free(dp[i]);
    free(dp);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (17, 'horse ros', '3', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (17, 'intention execution', '5', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (17, 'abc abc', '0', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  18, 'Reverse Linked List', 'reverse-linked-list', 'Given the head of a singly linked list with <code>n</code> elements, reverse the list, and print the reversed elements space-separated.', '0 <= n <= 5000<br/>-5000 <= Node.val <= 5000',
  1, 7,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> a(n);
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = n - 1; i >= 0; i--) {
        cout << a[i] << (i == 0 ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    print(" ".join(map(str, a[::-1])))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = sc.nextInt();
        for (int i = n - 1; i >= 0; i--) {
            System.out.print(a[i] + (i == 0 ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* a = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);
    for (int i = n - 1; i >= 0; i--) {
        printf("%d%s", a[i], (i == 0 ? "" : " "));
    }
    printf("\n");
    free(a);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (18, '5
1 2 3 4 5', '5 4 3 2 1', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (18, '2
1 2', '2 1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (18, '1
99', '99', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  19, 'Invert Binary Tree', 'invert-binary-tree', 'Given the root of a binary tree represented as level-order array of <code>n</code> nodes, invert the tree (swap left and right children for every node) and print the new level-order traversal.', '0 <= n <= 100',
  1, 9,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> a(n);
    for (int i = 0; i < n; i++) cin >> a[i];

    // For a complete binary tree level by level, reverse each level
    int levelStart = 0, levelSize = 1;
    while (levelStart < n) {
        int levelEnd = min(n, levelStart + levelSize);
        reverse(a.begin() + levelStart, a.begin() + levelEnd);
        levelStart += levelSize;
        levelSize *= 2;
    }

    for (int i = 0; i < n; i++) {
        cout << a[i] << (i + 1 == n ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    level_start, level_size = 0, 1
    while level_start < n:
        level_end = min(n, level_start + level_size)
        a[level_start:level_end] = reversed(a[level_start:level_end])
        level_start += level_size
        level_size *= 2
    print(" ".join(map(str, a)))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = sc.nextInt();
        int levelStart = 0, levelSize = 1;
        while (levelStart < n) {
            int levelEnd = Math.min(n, levelStart + levelSize);
            for (int l = levelStart, r = levelEnd - 1; l < r; l++, r--) {
                int tmp = a[l]; a[l] = a[r]; a[r] = tmp;
            }
            levelStart += levelSize;
            levelSize *= 2;
        }
        for (int i = 0; i < n; i++) {
            System.out.print(a[i] + (i + 1 == n ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* a = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);

    int levelStart = 0, levelSize = 1;
    while (levelStart < n) {
        int levelEnd = levelStart + levelSize;
        if (levelEnd > n) levelEnd = n;
        for (int i = levelStart, j = levelEnd - 1; i < j; i++, j--) {
            int tmp = a[i]; a[i] = a[j]; a[j] = tmp;
        }
        levelStart += levelSize;
        levelSize *= 2;
    }
    for (int i = 0; i < n; i++) {
        printf("%d%s", a[i], (i + 1 == n ? "" : " "));
    }
    printf("\n");
    free(a);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (19, '7
4 2 7 1 3 6 9', '4 7 2 9 6 3 1', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (19, '3
2 1 3', '2 3 1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (19, '1
1', '1', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  20, 'Min Stack', 'min-stack', 'Design a stack that supports push, pop, top, and retrieving the minimum element in constant time. Process <code>n</code> operations (<code>push x</code>, <code>pop</code>, <code>top</code>, <code>getMin</code>) and output the results for <code>top</code> and <code>getMin</code>.', '1 <= n <= 3 * 10^4',
  2, 6,
  '#include <iostream>
#include <string>
#include <stack>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    stack<long long> s, minS;
    for (int i = 0; i < n; i++) {
        string op;
        cin >> op;
        if (op == "push") {
            long long val; cin >> val;
            s.push(val);
            if (minS.empty() || val <= minS.top()) minS.push(val);
        } else if (op == "pop") {
            if (!s.empty()) {
                if (s.top() == minS.top()) minS.pop();
                s.pop();
            }
        } else if (op == "top") {
            if (!s.empty()) cout << s.top() << endl;
        } else if (op == "getMin") {
            if (!minS.empty()) cout << minS.top() << endl;
        }
    }
    return 0;
}
',
  'import sys

def main():
    tokens = sys.stdin.read().split()
    if not tokens:
        return
    n = int(tokens[0])
    idx = 1
    s, min_s = [], []
    for _ in range(n):
        op = tokens[idx]; idx += 1
        if op == "push":
            val = int(tokens[idx]); idx += 1
            s.append(val)
            if not min_s or val <= min_s[-1]:
                min_s.append(val)
        elif op == "pop":
            if s:
                val = s.pop()
                if val == min_s[-1]:
                    min_s.pop()
        elif op == "top":
            if s: print(s[-1])
        elif op == "getMin":
            if min_s: print(min_s[-1])

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        Deque<Long> s = new ArrayDeque<>();
        Deque<Long> minS = new ArrayDeque<>();
        for (int i = 0; i < n; i++) {
            String op = sc.next();
            if (op.equals("push")) {
                long val = sc.nextLong();
                s.push(val);
                if (minS.isEmpty() || val <= minS.peek()) minS.push(val);
            } else if (op.equals("pop")) {
                if (!s.isEmpty()) {
                    long val = s.pop();
                    if (val == minS.peek()) minS.pop();
                }
            } else if (op.equals("top")) {
                if (!s.isEmpty()) System.out.println(s.peek());
            } else if (op.equals("getMin")) {
                if (!minS.isEmpty()) System.out.println(minS.peek());
            }
        }
    }
}
',
  '#include <stdio.h>
#include <string.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    long long s[10005], minS[10005];
    int top = -1, minTop = -1;
    for (int i = 0; i < n; i++) {
        char op[16];
        scanf("%s", op);
        if (strcmp(op, "push") == 0) {
            long long val; scanf("%lld", &val);
            s[++top] = val;
            if (minTop == -1 || val <= minS[minTop]) minS[++minTop] = val;
        } else if (strcmp(op, "pop") == 0) {
            if (top >= 0) {
                if (s[top] == minS[minTop]) minTop--;
                top--;
            }
        } else if (strcmp(op, "top") == 0) {
            if (top >= 0) printf("%lld\n", s[top]);
        } else if (strcmp(op, "getMin") == 0) {
            if (minTop >= 0) printf("%lld\n", minS[minTop]);
        }
    }
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (20, '7
push -2
push 0
push -3
getMin
pop
top
getMin', '-3
0
-2', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (20, '4
push 10
push 20
getMin
top', '10
20', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (20, '3
push 5
top
getMin', '5
5', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  21, 'Daily Temperatures', 'daily-temperatures', 'Given an array of integers <code>temperatures</code> represents the daily temperatures, return an array <code>answer</code> such that <code>answer[i]</code> is the number of days you have to wait after the <code>i-th</code> day to get a warmer temperature. If there is no future day for which this is possible, keep <code>answer[i] == 0</code> instead.', '1 <= temperatures.length <= 10^5<br/>30 <= temperatures[i] <= 100',
  2, 6,
  '#include <iostream>
#include <vector>
#include <stack>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> t(n), res(n, 0);
    for (int i = 0; i < n; i++) cin >> t[i];

    stack<int> st;
    for (int i = 0; i < n; i++) {
        while (!st.empty() && t[i] > t[st.top()]) {
            int prev = st.top(); st.pop();
            res[prev] = i - prev;
        }
        st.push(i);
    }

    for (int i = 0; i < n; i++) {
        cout << res[i] << (i + 1 == n ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    t = nums[1:1+n]
    res = [0] * n
    stack = []
    for i in range(n):
        while stack and t[i] > t[stack[-1]]:
            prev = stack.pop()
            res[prev] = i - prev
        stack.append(i)
    print(" ".join(map(str, res)))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] t = new int[n];
        for (int i = 0; i < n; i++) t[i] = sc.nextInt();
        int[] res = new int[n];
        Deque<Integer> st = new ArrayDeque<>();
        for (int i = 0; i < n; i++) {
            while (!st.isEmpty() && t[i] > t[st.peek()]) {
                int prev = st.pop();
                res[prev] = i - prev;
            }
            st.push(i);
        }
        for (int i = 0; i < n; i++) {
            System.out.print(res[i] + (i + 1 == n ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* t = (int*)malloc(n * sizeof(int));
    int* res = (int*)calloc(n, sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &t[i]);

    int* stack = (int*)malloc(n * sizeof(int));
    int top = -1;
    for (int i = 0; i < n; i++) {
        while (top >= 0 && t[i] > t[stack[top]]) {
            int prev = stack[top--];
            res[prev] = i - prev;
        }
        stack[++top] = i;
    }
    for (int i = 0; i < n; i++) {
        printf("%d%s", res[i], (i + 1 == n ? "" : " "));
    }
    printf("\n");
    free(t); free(res); free(stack);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (21, '8
73 74 75 71 69 72 76 73', '1 1 4 2 1 1 0 0', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (21, '4
30 40 50 60', '1 1 1 0', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (21, '3
30 60 90', '1 1 0', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  22, 'Subarray Sum Equals K', 'subarray-sum-equals-k', 'Given an array of integers <code>nums</code> and an integer <code>k</code>, return the total number of subarrays whose sum equals to <code>k</code>.', '1 <= nums.length <= 2 * 10^4<br/>-1000 <= nums[i] <= 1000<br/>-10^7 <= k <= 10^7',
  2, 3,
  '#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];
    int k; cin >> k;

    unordered_map<long long, int> prefixCounts;
    prefixCounts[0] = 1;
    long long sum = 0, count = 0;
    for (int x : nums) {
        sum += x;
        if (prefixCounts.count(sum - k)) count += prefixCounts[sum - k];
        prefixCounts[sum]++;
    }
    cout << count << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    k = nums[1+n]
    counts = {0: 1}
    s = count = 0
    for x in a:
        s += x
        count += counts.get(s - k, 0)
        counts[s] = counts.get(s, 0) + 1
    print(count)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = sc.nextInt();
        int k = sc.nextInt();
        Map<Long, Integer> counts = new HashMap<>();
        counts.put(0L, 1);
        long sum = 0, count = 0;
        for (int x : a) {
            sum += x;
            count += counts.getOrDefault(sum - k, 0);
            counts.put(sum, counts.getOrDefault(sum, 0) + 1);
        }
        System.out.println(count);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int k; scanf("%d", &k);

    long long count = 0;
    for (int i = 0; i < n; i++) {
        long long sum = 0;
        for (int j = i; j < n; j++) {
            sum += nums[j];
            if (sum == k) count++;
        }
    }
    printf("%lld\n", count);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (22, '3
1 1 1
2', '2', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (22, '3
1 2 3
3', '2', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (22, '5
1 -1 0 1 -1
0', '6', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  23, 'House Robber', 'house-robber', 'You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night. Return the maximum amount of money you can rob tonight without alerting the police.', '1 <= nums.length <= 100<br/>0 <= nums[i] <= 400',
  2, 8,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];

    if (n == 1) { cout << nums[0] << endl; return 0; }
    int prev2 = 0, prev1 = 0;
    for (int x : nums) {
        int curr = max(prev1, prev2 + x);
        prev2 = prev1;
        prev1 = curr;
    }
    cout << prev1 << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    prev2 = prev1 = 0
    for x in a:
        prev2, prev1 = prev1, max(prev1, prev2 + x)
    print(prev1)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int prev2 = 0, prev1 = 0;
        for (int i = 0; i < n; i++) {
            int x = sc.nextInt();
            int curr = Math.max(prev1, prev2 + x);
            prev2 = prev1;
            prev1 = curr;
        }
        System.out.println(prev1);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);

    if (n == 1) { printf("%d\n", nums[0]); free(nums); return 0; }
    int prev2 = 0, prev1 = 0;
    for (int i = 0; i < n; i++) {
        int cand = prev2 + nums[i];
        int curr = (prev1 > cand) ? prev1 : cand;
        prev2 = prev1;
        prev1 = curr;
    }
    printf("%d\n", prev1);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (23, '4
1 2 3 1', '4', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (23, '5
2 7 9 3 1', '12', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (23, '1
50', '50', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  24, 'Jump Game', 'jump-game', 'You are given an integer array <code>nums</code>. You are initially positioned at the array''s first index, and each element in the array represents your maximum jump length at that position. Return <code>true</code> if you can reach the last index, or <code>false</code> otherwise.', '1 <= nums.length <= 10^4<br/>0 <= nums[i] <= 10^5',
  2, 8,
  '#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];

    int maxReach = 0;
    for (int i = 0; i < n; i++) {
        if (i > maxReach) { cout << "false" << endl; return 0; }
        maxReach = max(maxReach, i + nums[i]);
    }
    cout << "true" << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    max_reach = 0
    for i, x in enumerate(a):
        if i > max_reach:
            print("false")
            return
        max_reach = max(max_reach, i + x)
    print("true")

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int maxReach = 0;
        for (int i = 0; i < n; i++) {
            int x = sc.nextInt();
            if (i > maxReach) { System.out.println("false"); return; }
            maxReach = Math.max(maxReach, i + x);
        }
        System.out.println("true");
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);

    int maxReach = 0;
    for (int i = 0; i < n; i++) {
        if (i > maxReach) { printf("false\n"); free(nums); return 0; }
        if (i + nums[i] > maxReach) maxReach = i + nums[i];
    }
    printf("true\n");
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (24, '5
2 3 1 1 4', 'true', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (24, '5
3 2 1 0 4', 'false', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (24, '1
0', 'true', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  25, 'Search in Rotated Sorted Array', 'search-in-rotated-sorted-array', 'Given the array <code>nums</code> after the possible rotation and an integer <code>target</code>, return the index of <code>target</code> if it is in <code>nums</code>, or <code>-1</code> if it is not in <code>nums</code>.', '1 <= nums.length <= 5000<br/>All values of nums are unique.',
  2, 5,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];
    int target; cin >> target;

    int l = 0, r = n - 1, ans = -1;
    while (l <= r) {
        int mid = l + (r - l) / 2;
        if (nums[mid] == target) { ans = mid; break; }
        if (nums[l] <= nums[mid]) {
            if (nums[l] <= target && target < nums[mid]) r = mid - 1;
            else l = mid + 1;
        } else {
            if (nums[mid] < target && target <= nums[r]) l = mid + 1;
            else r = mid - 1;
        }
    }
    cout << ans << endl;
    return 0;
}
',
  'import sys

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    nums = data[1:1+n]
    target = data[1+n]
    l, r = 0, n - 1
    ans = -1
    while l <= r:
        mid = (l + r) // 2
        if nums[mid] == target:
            ans = mid
            break
        if nums[l] <= nums[mid]:
            if nums[l] <= target < nums[mid]:
                r = mid - 1
            else:
                l = mid + 1
        else:
            if nums[mid] < target <= nums[r]:
                l = mid + 1
            else:
                r = mid - 1
    print(ans)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] nums = new int[n];
        for (int i = 0; i < n; i++) nums[i] = sc.nextInt();
        int target = sc.nextInt();
        int l = 0, r = n - 1, ans = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (nums[mid] == target) { ans = mid; break; }
            if (nums[l] <= nums[mid]) {
                if (nums[l] <= target && target < nums[mid]) r = mid - 1;
                else l = mid + 1;
            } else {
                if (nums[mid] < target && target <= nums[r]) l = mid + 1;
                else r = mid - 1;
            }
        }
        System.out.println(ans);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int target; scanf("%d", &target);

    int l = 0, r = n - 1, ans = -1;
    while (l <= r) {
        int mid = l + (r - l) / 2;
        if (nums[mid] == target) { ans = mid; break; }
        if (nums[l] <= nums[mid]) {
            if (nums[l] <= target && target < nums[mid]) r = mid - 1;
            else l = mid + 1;
        } else {
            if (nums[mid] < target && target <= nums[r]) l = mid + 1;
            else r = mid - 1;
        }
    }
    printf("%d\n", ans);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (25, '7
4 5 6 7 0 1 2
0', '4', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (25, '7
4 5 6 7 0 1 2
3', '-1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (25, '1
1
0', '-1', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  26, 'Find Minimum in Rotated Sorted Array', 'find-minimum-in-rotated-sorted-array', 'Suppose an array of length <code>n</code> sorted in ascending order is rotated between 1 and n times. Given the sorted rotated array <code>nums</code> of unique elements, return the minimum element of this array in O(log n) time.', 'n == nums.length<br/>1 <= n <= 5000<br/>All elements are unique.',
  2, 5,
  '#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];

    int l = 0, r = n - 1;
    while (l < r) {
        int mid = l + (r - l) / 2;
        if (nums[mid] > nums[r]) l = mid + 1;
        else r = mid;
    }
    cout << nums[l] << endl;
    return 0;
}
',
  'import sys

def main():
    nums = [int(x) for x in sys.stdin.read().split()]
    if not nums:
        return
    n = nums[0]
    a = nums[1:1+n]
    l, r = 0, n - 1
    while l < r:
        mid = (l + r) // 2
        if a[mid] > a[r]:
            l = mid + 1
        else:
            r = mid
    print(a[l])

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] nums = new int[n];
        for (int i = 0; i < n; i++) nums[i] = sc.nextInt();
        int l = 0, r = n - 1;
        while (l < r) {
            int mid = l + (r - l) / 2;
            if (nums[mid] > nums[r]) l = mid + 1;
            else r = mid;
        }
        System.out.println(nums[l]);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);

    int l = 0, r = n - 1;
    while (l < r) {
        int mid = l + (r - l) / 2;
        if (nums[mid] > nums[r]) l = mid + 1;
        else r = mid;
    }
    printf("%d\n", nums[l]);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (26, '5
3 4 5 1 2', '1', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (26, '7
4 5 6 7 0 1 2', '0', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (26, '4
11 13 15 17', '11', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  27, 'Kth Largest Element in an Array', 'kth-largest-element-in-an-array', 'Given an integer array <code>nums</code> and an integer <code>k</code>, return the <code>k-th</code> largest element in the array.', '1 <= k <= nums.length <= 10^5<br/>-10^4 <= nums[i] <= 10^4',
  2, 1,
  '#include <iostream>
#include <vector>
#include <queue>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    vector<int> nums(n);
    for (int i = 0; i < n; i++) cin >> nums[i];
    int k; cin >> k;

    priority_queue<int, vector<int>, greater<int>> pq;
    for (int x : nums) {
        pq.push(x);
        if ((int)pq.size() > k) pq.pop();
    }
    cout << pq.top() << endl;
    return 0;
}
',
  'import sys
import heapq

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    nums = data[1:1+n]
    k = data[1+n]
    pq = []
    for x in nums:
        heapq.heappush(pq, x)
        if len(pq) > k:
            heapq.heappop(pq)
    print(pq[0])

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        int[] nums = new int[n];
        for (int i = 0; i < n; i++) nums[i] = sc.nextInt();
        int k = sc.nextInt();
        PriorityQueue<Integer> pq = new PriorityQueue<>();
        for (int x : nums) {
            pq.offer(x);
            if (pq.size() > k) pq.poll();
        }
        System.out.println(pq.peek());
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int cmpDesc(const void* a, const void* b) {
    return (*(int*)b - *(int*)a);
}

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int k; scanf("%d", &k);

    qsort(nums, n, sizeof(int), cmpDesc);
    printf("%d\n", nums[k - 1]);
    free(nums);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (27, '6
3 2 1 5 6 4
2', '5', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (27, '9
3 2 3 1 2 4 5 5 6
4', '4', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (27, '1
100
1', '100', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  28, 'Top K Frequent Elements', 'top-k-frequent-elements', 'Given an integer array <code>nums</code> and an integer <code>k</code>, return the <code>k</code> most frequent elements sorted in descending order of frequency.', '1 <= nums.length <= 10^5<br/>k is in the range [1, the number of unique elements in the array].',
  2, 3,
  '#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
using namespace std;

int main() {
    int n;
    if (!(cin >> n)) return 0;
    unordered_map<int, int> counts;
    for (int i = 0; i < n; i++) {
        int x; cin >> x;
        counts[x]++;
    }
    int k; cin >> k;

    vector<pair<int, int>> freq;
    for (auto& p : counts) freq.push_back({p.second, p.first});
    sort(freq.rbegin(), freq.rend());

    for (int i = 0; i < k; i++) {
        cout << freq[i].second << (i + 1 == k ? "" : " ");
    }
    cout << endl;
    return 0;
}
',
  'import sys
from collections import Counter

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    n = data[0]
    nums = data[1:1+n]
    k = data[1+n]
    counts = Counter(nums)
    most_common = counts.most_common(k)
    print(" ".join(str(item[0]) for item in most_common))

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        Map<Integer, Integer> counts = new HashMap<>();
        for (int i = 0; i < n; i++) {
            int x = sc.nextInt();
            counts.put(x, counts.getOrDefault(x, 0) + 1);
        }
        int k = sc.nextInt();
        List<Map.Entry<Integer, Integer>> list = new ArrayList<>(counts.entrySet());
        list.sort((a, b) -> b.getValue() - a.getValue());
        for (int i = 0; i < k; i++) {
            System.out.print(list.get(i).getKey() + (i + 1 == k ? "" : " "));
        }
        System.out.println();
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int val;
    int count;
} Freq;

int cmpFreq(const void* a, const void* b) {
    Freq* fa = (Freq*)a;
    Freq* fb = (Freq*)b;
    return fb->count - fa->count;
}

int cmpInt(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

int main() {
    int n;
    if (scanf("%d", &n) != 1) return 0;
    int* nums = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &nums[i]);
    int k; scanf("%d", &k);

    qsort(nums, n, sizeof(int), cmpInt);

    Freq* freqs = (Freq*)malloc(n * sizeof(Freq));
    int fSize = 0;
    for (int i = 0; i < n; i++) {
        if (i == 0 || nums[i] != nums[i - 1]) {
            freqs[fSize].val = nums[i];
            freqs[fSize].count = 1;
            fSize++;
        } else {
            freqs[fSize - 1].count++;
        }
    }

    qsort(freqs, fSize, sizeof(Freq), cmpFreq);

    for (int i = 0; i < k; i++) {
        printf("%d%s", freqs[i].val, (i + 1 == k ? "" : " "));
    }
    printf("\n");
    free(nums); free(freqs);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (28, '6
1 1 1 2 2 3
2', '1 2', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (28, '1
1
1', '1', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (28, '7
4 4 4 4 5 5 6
2', '4 5', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  29, 'Longest Palindromic Substring', 'longest-palindromic-substring', 'Given a string <code>s</code>, return the longest palindromic substring in <code>s</code>.', '1 <= s.length <= 1000<br/>s consist of only digits and English letters.',
  2, 2,
  '#include <iostream>
#include <string>
using namespace std;

string expand(const string& s, int l, int r) {
    while (l >= 0 && r < (int)s.size() && s[l] == s[r]) {
        l--; r++;
    }
    return s.substr(l + 1, r - l - 1);
}

int main() {
    string s;
    if (!(cin >> s)) return 0;
    string longest = "";
    for (int i = 0; i < (int)s.size(); i++) {
        string s1 = expand(s, i, i);
        string s2 = expand(s, i, i + 1);
        if (s1.size() > longest.size()) longest = s1;
        if (s2.size() > longest.size()) longest = s2;
    }
    cout << longest << endl;
    return 0;
}
',
  'import sys

def expand(s, l, r):
    while l >= 0 and r < len(s) and s[l] == s[r]:
        l -= 1
        r += 1
    return s[l + 1:r]

def main():
    s = sys.stdin.read().strip()
    if not s:
        return
    longest = ""
    for i in range(len(s)):
        s1 = expand(s, i, i)
        s2 = expand(s, i, i + 1)
        if len(s1) > len(longest): longest = s1
        if len(s2) > len(longest): longest = s2
    print(longest)

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    private static String expand(String s, int l, int r) {
        while (l >= 0 && r < s.length() && s.charAt(l) == s.charAt(r)) {
            l--; r++;
        }
        return s.substring(l + 1, r);
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;
        String s = sc.next();
        String longest = "";
        for (int i = 0; i < s.length(); i++) {
            String s1 = expand(s, i, i);
            String s2 = expand(s, i, i + 1);
            if (s1.length() > longest.length()) longest = s1;
            if (s2.length() > longest.length()) longest = s2;
        }
        System.out.println(longest);
    }
}
',
  '#include <stdio.h>
#include <string.h>

int main() {
    char s[1005];
    if (scanf("%s", s) != 1) return 0;
    int n = strlen(s);
    int bestStart = 0, bestLen = 1;

    for (int i = 0; i < n; i++) {
        int l = i, r = i;
        while (l >= 0 && r < n && s[l] == s[r]) {
            if (r - l + 1 > bestLen) {
                bestStart = l;
                bestLen = r - l + 1;
            }
            l--; r++;
        }
        l = i; r = i + 1;
        while (l >= 0 && r < n && s[l] == s[r]) {
            if (r - l + 1 > bestLen) {
                bestStart = l;
                bestLen = r - l + 1;
            }
            l--; r++;
        }
    }
    for (int i = 0; i < bestLen; i++) {
        putchar(s[bestStart + i]);
    }
    putchar(''\n'');
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (29, 'babad', 'bab', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (29, 'cbbd', 'bb', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (29, 'racecar', 'racecar', 0);

INSERT OR IGNORE INTO problems (problem_id, title, slug, description, constraints, difficulty_id, category_id, starter_cpp, starter_python, starter_java, starter_c) VALUES (
  30, 'Median of Two Sorted Arrays', 'median-of-two-sorted-arrays', 'Given two sorted arrays <code>nums1</code> and <code>nums2</code> of size <code>m</code> and <code>n</code> respectively, return the median of the two sorted arrays formatted with 1 decimal place.', 'nums1.length == m<br/>nums2.length == n<br/>0 <= m <= 1000<br/>0 <= n <= 1000',
  3, 5,
  '#include <iostream>
#include <vector>
#include <algorithm>
#include <iomanip>
using namespace std;

int main() {
    int m, n;
    if (!(cin >> m)) return 0;
    vector<int> a(m);
    for (int i = 0; i < m; i++) cin >> a[i];
    cin >> n;
    vector<int> b(n);
    for (int i = 0; i < n; i++) cin >> b[i];

    vector<int> merged;
    int i = 0, j = 0;
    while (i < m && j < n) {
        if (a[i] <= b[j]) merged.push_back(a[i++]);
        else merged.push_back(b[j++]);
    }
    while (i < m) merged.push_back(a[i++]);
    while (j < n) merged.push_back(b[j++]);

    int total = m + n;
    double median = 0.0;
    if (total % 2 == 1) {
        median = merged[total / 2];
    } else {
        median = (merged[total / 2 - 1] + merged[total / 2]) / 2.0;
    }
    cout << fixed << setprecision(1) << median << endl;
    return 0;
}
',
  'import sys

def main():
    data = [int(x) for x in sys.stdin.read().split()]
    if not data:
        return
    idx = 0
    m = data[idx]; idx += 1
    a = data[idx:idx+m]; idx += m
    n = data[idx]; idx += 1
    b = data[idx:idx+n]; idx += n
    
    merged = sorted(a + b)
    total = m + n
    if total % 2 == 1:
        ans = float(merged[total // 2])
    else:
        ans = (merged[total // 2 - 1] + merged[total // 2]) / 2.0
    print(f"{ans:.1f}")

if __name__ == "__main__":
    main()
',
  'import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        int m = sc.nextInt();
        List<Integer> list = new ArrayList<>();
        for (int i = 0; i < m; i++) list.add(sc.nextInt());
        int n = sc.nextInt();
        for (int i = 0; i < n; i++) list.add(sc.nextInt());
        Collections.sort(list);
        int total = m + n;
        double median = 0.0;
        if (total % 2 == 1) {
            median = list.get(total / 2);
        } else {
            median = (list.get(total / 2 - 1) + list.get(total / 2)) / 2.0;
        }
        System.out.printf(Locale.US, "%.1f\n", median);
    }
}
',
  '#include <stdio.h>
#include <stdlib.h>

int main() {
    int m, n;
    if (scanf("%d", &m) != 1) return 0;
    int* a = (int*)malloc((m + 1) * sizeof(int));
    for (int i = 0; i < m; i++) scanf("%d", &a[i]);
    scanf("%d", &n);
    int* b = (int*)malloc((n + 1) * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d", &b[i]);

    int* merged = (int*)malloc((m + n + 1) * sizeof(int));
    int i = 0, j = 0, k = 0;
    while (i < m && j < n) {
        if (a[i] <= b[j]) merged[k++] = a[i++];
        else merged[k++] = b[j++];
    }
    while (i < m) merged[k++] = a[i++];
    while (j < n) merged[k++] = b[j++];

    int total = m + n;
    double median = 0.0;
    if (total % 2 == 1) {
        median = merged[total / 2];
    } else {
        median = (merged[total / 2 - 1] + merged[total / 2]) / 2.0;
    }
    printf("%.1f\n", median);
    free(a); free(b); free(merged);
    return 0;
}
'
);

INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (30, '2
1 3
1
2', '2.0', 1);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (30, '2
1 2
2
3 4', '2.5', 0);
INSERT INTO test_cases (problem_id, input_data, expected_output, is_sample) VALUES (30, '0
1
1', '1.0', 0);

COMMIT;
