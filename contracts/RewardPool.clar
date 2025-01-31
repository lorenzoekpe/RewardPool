(define-data-var pool-owner principal tx-sender)
(define-data-var pool-balance uint u0)
(define-data-var reward-rate uint u100) ;; rewards added per block (example value)
(define-data-var last-compounded uint u0) ;; last block when rewards were compounded
(define-map deposits principal uint)

;; Helper function to ensure only the pool owner can perform certain actions
(define-private (is-owner (sender principal))
  (begin
    (asserts! (is-eq sender (var-get pool-owner)) (err u100))
    (ok true)))

;; Initialize the contract
(define-public (initialize (owner principal))
  (begin
    (asserts! (is-none (map-get? deposits owner)) (err u101))
    (var-set pool-owner owner)
    (ok "Contract initialized")))

;; Deposit tokens into the pool
(define-public (deposit (amount uint))
  (begin
    (asserts! (> amount u0) (err u102))
    (let ((existing-balance (default-to u0 (map-get? deposits tx-sender))))
      (map-set deposits tx-sender (+ existing-balance amount))
      (var-set pool-balance (+ (var-get pool-balance) amount))
      (ok (+ existing-balance amount)))))

;; Compound rewards for all participants
(define-public (compound-rewards)
  (begin
    (try! (is-owner tx-sender))
    (let ((current-block tenure-height)
          (last-comp (var-get last-compounded)))
      (asserts! (> current-block last-comp) (err u103))
      ;; Calculate rewards based on blocks elapsed
      (let ((elapsed (- current-block last-comp))
            (total-reward (* elapsed (var-get reward-rate))))
        (var-set last-compounded current-block)
        (var-set pool-balance (+ (var-get pool-balance) total-reward))
        (ok total-reward)))))

;; Withdraw tokens and rewards
(define-public (withdraw)
  (begin
    (let ((depositor-balance (default-to u0 (map-get? deposits tx-sender))))
      (asserts! (> depositor-balance u0) (err u104))
      (let ((total-balance (var-get pool-balance))
            (total-reward (* (var-get reward-rate) (- tenure-height (var-get last-compounded))))
            (share (/ (* depositor-balance u100000) total-balance)))
        ;; Update balances and calculate reward share
        (let ((reward-portion (/ (* share total-reward) u100000)))
          (map-delete deposits tx-sender)
          (var-set pool-balance (- (var-get pool-balance) depositor-balance))
          (ok (+ depositor-balance reward-portion)))))))