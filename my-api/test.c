int solve() {
    int n;
    scanf("%d", &n);
    int arr[n];
    for (int i = 0 ; i < n ; i++){
        scanf("%d", &arr[i]);
    }
    int sum = 0;
    for (int i = 0; i<n ; i++){
        if (sum>=arr[i]){
            sum -= arr[i];
        }else{
            sum+= arr[i];
        }
    }
    return sum;
}