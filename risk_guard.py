def calculate_position_size(balance, score, price, stop_loss_pct):
    """
    Example position sizing: 1% risk per trade.
    """
    risk_amount = balance * 0.01
    sl_distance = price * stop_loss_pct
    if sl_distance == 0:
        return 0
    size = risk_amount / sl_distance
    return round(size, 4)

def should_continue_trading(state):
    """
    Placeholder: always return True.
    Add daily profit/loss checks later.
    """
    return True, "Continue trading"
