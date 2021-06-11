import React from "react";
import DayPicker from "react-day-picker";
import "react-day-picker/lib/style.css";

type Days = { [index: number]: Date[] };

export type DatePickerProps = {
  index: number;
  selectedDays: Days;
  setSelectedDays: React.Dispatch<React.SetStateAction<Days>>;
};

function isSameDay(d1: Date, d2: Date): boolean {
  return d1.toLocaleDateString() === d2.toLocaleDateString();
}

const mergeDays = (prev: Days, index: number, day: any, selected: boolean) => {
  let newDates: Days;
  if (selected) {
    // toggle unselect
    const existing = prev[index];
    const updated = existing.filter((d) => !isSameDay(day, d));
    newDates = { ...prev, ...{ [index]: updated } };
  } else {
    // toggle select
    if (index in prev) {
      newDates = {
        ...prev,
        ...{ [index]: [...prev[index], day].sort((a, b) => a - b) },
      };
    } else {
      newDates = { ...prev, ...{ [index]: [day] } };
    }
  }
  console.log("newDates:", newDates);
  return newDates;
};

const DatePicker = ({
  index,
  selectedDays,
  setSelectedDays,
}: DatePickerProps) => {
  return (
    <DayPicker
      selectedDays={selectedDays[index]}
      onDayClick={(day, { selected }: any) => {
        setSelectedDays((prev) => mergeDays(prev, index, day, selected));
      }}
    />
  );
};

export default DatePicker;
