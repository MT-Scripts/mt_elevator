import React, { useState, useRef, useEffect } from "react";
import { DEFAULT_THEME, Paper, Text, Divider, ActionIcon } from "@mantine/core";
import { modals } from "@mantine/modals";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";

const Elevator: React.FC = () => {
    const theme = DEFAULT_THEME;
    const [elevatorLevels, setElevatorLevels] = useState([])
    const [currentLevel, setCurrentLevel] = useState([])
    const [elevatorLabel, setElevatorLevel] = useState('')
    const [currentElevator, setCurrentElevator] = useState(0)

    useNuiEvent<any>('updateElevator', (data) => {
        setCurrentElevator(data.currentElevator)
        setElevatorLevel(data.elevatorLabel)
        setElevatorLevels(data.elevatorLevels)
        setCurrentLevel(data.currentLevel)
    });

    return (
        <div
            style={{
                width: "100%",
                height: "100%",
                margin: -8,
                position: "fixed",
                userSelect: 'none',
                display: 'flex',
                alignItems: 'center'
            }}
        >
            <Paper
                maw={193}
                radius="sm"
                withBorder
                style={{
                    position: "absolute",
                    right: 50,
                    backgroundColor: theme.colors.dark[8]
                }}
            >
                <Paper
                    style={{
                        display: 'flex',
                        justifyContent: 'center',
                        padding: 5
                    }}
                >
                    <Text>{elevatorLabel}</Text>
                </Paper>
                <Divider />
                <div
                    style={{
                        width: '100%',
                        display: 'flex',
                        flexDirection: 'row',
                        justifyContent: 'flex-start',
                        flexWrap: 'wrap',
                        padding: 10,
                        gap: 10
                    }}
                >
                    {elevatorLevels && elevatorLevels.map(({ id, label }) => (<ActionIcon
                        size={80}
                        variant="light"
                        color="blue"
                        disabled={(currentLevel == id)}
                        onClick={() => {
                            fetchNui('useElevator', { currentElevator: currentElevator, id: id })
                        }}
                    >
                        <Text size={60}>{label}</Text>
                    </ActionIcon>))}
                </div>
            </Paper>
        </div>
    );
};

export default Elevator;