import React, { useState } from "react";
import "./Elevator.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import ElevatorButton from "./ElevatorButton";
import { useNuiEvent } from "../hooks/useNuiEvent";

debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

const Elevator: React.FC = () => {
  const [currentElevator, setCurrentElevator] = useState<number | null>(null);
  const [elevatorLevels, setElevatorLevels] = useState<number[]>([]);
  const [currentLevel, setCurrentLevel] = useState<number | null>(null);

  useNuiEvent<any>('updateElevator', (data) => {
    setCurrentElevator(data.currentElevator)
    setElevatorLevels(data.elevatorLevels)
    setCurrentLevel(data.currentLevel)
  });

  const handleClick = (level: number) => {
    fetchNui('hideFrame');
    fetchNui('goToLevel', {
      currentElevator,
      currentLevel,
      level
    });
  };

  return (
    <div className="nui-wrapper">
      <div className="elevator-ui">
        {elevatorLevels.length === 2 ? (
          <div className="vertical-btns">
            <ElevatorButton level={elevatorLevels[0]} onClick={() => handleClick(elevatorLevels[0])} isUp disabled={currentLevel === elevatorLevels[0]} />
            <ElevatorButton level={elevatorLevels[1]} onClick={() => handleClick(elevatorLevels[1])} isDown disabled={currentLevel === elevatorLevels[1]} />
          </div>
        ) : (
          <div className="grid-btns">
            {elevatorLevels.map((level) => (
              <ElevatorButton key={level} level={level} onClick={() => handleClick(level)} disabled={currentLevel === level} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default Elevator;
