import React from "react";

interface ElevatorButtonProps {
    level: number;
    onClick: () => void;
    isUp?: boolean;
    isDown?: boolean;
    disabled?: boolean;
}

const ElevatorButton: React.FC<ElevatorButtonProps> = ({ level, onClick, isUp, isDown, disabled }) => {
    const showNumber = !(isUp || isDown);
    return (
        <button className="elevator-btn" onClick={onClick} disabled={disabled}>
            <img src="button.webp" alt="button" className="button-img" />
            {showNumber && <span className="level-number">{level}</span>}
            {isUp && <span className="level-number">▲</span>}
            {isDown && <span className="level-number">▼</span>}
        </button>
    );
};

export default ElevatorButton;
